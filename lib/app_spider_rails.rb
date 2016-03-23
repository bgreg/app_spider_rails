require "net/http"
require "logger"
require "app_spider_rails/version"

module AppSpiderRails
  def self.set_logger(path = "logs/app_spider_rails.log")
    Logger.new(path)
  end

  def self.load_authorization(path = "lib/app_spider_rails/config/auth.yml")
    extract_yaml(path)
  end

  def self.load_paths(path = "lib/app_spider_rails/config/paths.yml")
    extract_yaml(path)
  end

  def self.extract_yaml(path)
    YAML.load(File.read(File.expand_path(path)))
  end
end
