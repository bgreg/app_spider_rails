module AppSpiderRails
  class Connection
    NO_RESPONSE_MESSAGE = "No error message from AppSpider was returned"
    attr_reader :token, :user
    attr_accessor :log, :paths, :url, :response

    def initialize(support, options = {})
      @log       = options.fetch(:log,   support.logger)
      @paths     = options.fetch(:paths, support.paths)
      @url       = options.fetch(:url,   @paths.fetch(:url))
      @user      = options.fetch(:user)
    end

    def authenticate!
      uri = URI(url + paths.fetch(:login))
      log.info( ", [#{self.class}::#{__method__}], uri: #{uri.inspect}")

      http_response = AppSpiderRails::Http.new.post!(
        uri,
        name: user.username,
        password: user.password
      )
      set_token(Response.new(http_response))
    end

    private

    def set_token(response)
      raise CannotAuthenticate, "bad response: #{response.raw.inspect}" if response.failed?
      message = response.message

      if message.fetch("IsSuccess")
        @token = message.fetch("Token")
        response
      else
        raise CannotAuthenticate, message.fetch("ErrorMessage", NO_RESPONSE_MESSAGE)
      end
    end
  end
end
