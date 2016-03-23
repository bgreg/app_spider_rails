module AppSpiderRails
  class Connection
    attr_reader :uri
    attr_reader :token

    def self.build_from(auth_file)
      auth = AppSpiderRails.load_authorization(auth_file)
      AppSpiderRails::User.new(auth.fetch(:username), auth.fetch(:password))
      new(auth.fetch(:url))
    end

    def initialize(url, options = {})
      @log   = options.fetch(:log, AppSpiderRails.set_logger)
      @paths = options.fetch(:paths, AppSpiderRails.load_paths)
      @uri   = url + @paths.fetch(:base)
    end

    def authenticate(user)
      path = URI(uri + paths.fetch(:login))
      log.info("attempting to connect to: #{path}")

      Net::HTTP.post_form(
        path,
        name:     user.username,
        password: user.password
      )
    end

    private

    attr_accessor :log, :paths
  end
end
