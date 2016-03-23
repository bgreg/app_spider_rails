module AppSpiderRails
  class Support
    attr_accessor :logger, :paths, :auths

    def self.build
      support = new
      support.load_paths
      support.load_authorization
      support.load_logger
      support
    end

    def load_logger(path = "logs/app_spider_rails.log")
      @logger = Logger.new(path)
    end

    def load_authorization(path = "lib/app_spider_rails/config/auth.yml")
      @auths = extract_yaml(path)
    end

    def load_paths(path = "lib/app_spider_rails/config/paths.yml")
      @paths = extract_yaml(path)
    end

    private

    def extract_yaml(path)
      YAML.load(File.read(File.expand_path(path)))
    end
  end
end
