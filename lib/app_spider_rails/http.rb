module AppSpiderRails
  class Http
    WAIT_TIME_DEFAULT = 30
    attr_accessor :wait_time

    def initialize
      @wait_time = WAIT_TIME_DEFAULT
    end

    def post!(path, form, connection = nil)
      timeout { Net::HTTP.post_form(path, form) }
    end

    def get!(path, connection = nil)
      uri = URI(connection.url + path)
      connection.log.info( ", [#{self.class}::#{__method__}], uri: #{uri.inspect}")

      http_response = timeout do
        Net::HTTP.start(uri.host, uri.port) do |http|
          request = Net::HTTP::Get.new(uri.request_uri)
          request['Authorization'] = "Basic #{connection.token}"
          http.request(request)
        end
      end
      Response.new(http_response)
    end

    def timeout
      Timeout.timeout(wait_time) { yield }
    end
  end
end
