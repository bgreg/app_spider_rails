module AppSpiderRails
  class Connection
    NO_RESPONSE_MESSAGE = "No error message from AppSpider was returned"
    WAIT_TIME_DEFAULT   = 30
    attr_reader :token, :user
    attr_accessor :response, :wait_time

    def initialize(support, options = {})
      @wait_time = WAIT_TIME_DEFAULT
      @log       = options.fetch(:log,   support.logger)
      @paths     = options.fetch(:paths, support.paths)
      @url       = options.fetch(:url,   @paths.fetch(:url))
      @user      = options.fetch(:user)
    end

    def authenticate!
      uri = URI(url + paths.fetch(:login))
      log.info( ", [#{self.class}::#{__method__}], uri: #{uri.inspect}")

      http_response = post!(uri, name: user.username, password: user.password)
      @response     = Response.new(http_response)
      set_token
    end

    def post!(path, form)
      timeout { Net::HTTP.post_form(path, form) }
    end

    def get!(path)
      uri = URI(url + path)
      log.info( ", [#{self.class}::#{__method__}], uri: #{uri.inspect}")

      http_response = timeout do
        Net::HTTP.start(uri.host, uri.port) do |http|
          request = Net::HTTP::Get.new(uri.request_uri)
          request['Authorization'] = "Basic #{token}"
          http.request(request)
        end
      end
      Response.new(http_response)
    end

    private

    def set_token
      raise CannotAuthenticate, "bad response: #{response.raw.inspect}"if @response.failed?
      message = response.message

      if message.fetch("IsSuccess")
        @token = message.fetch("Token")
        true
      else
        raise CannotAuthenticate, message.fetch("ErrorMessage", NO_RESPONSE_MESSAGE)
      end
    end

    def timeout
      Timeout::timeout(wait_time) { yield }
    end

    attr_accessor :log, :paths, :url
  end
end
