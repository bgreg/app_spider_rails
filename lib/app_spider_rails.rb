require "net/http"
require "logger"
require "app_spider_rails/version"

module AppSpiderRails
  PATH = {
    base:  "AppSpiderEnterprise/rest/v1/",
    login: "Authentication/Login"
  }

  def self.set_logger(path = "logs/app_spider_rails.log")
    Logger.new(path)
  end

  def self.load_authorization(file = "lib/app_spider_rails/config/auth.yml")
    path = File.expand_path(file)
    YAML.load(File.read(path))
  end
end
