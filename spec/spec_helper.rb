$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'bundler/setup'
Bundler.setup

require 'webmock/rspec'
require 'pry'
require "net/http"
require "logger"

require 'app_spider_rails'

Dir[File.expand_path("spec/support/**/*.rb")].each { |f| require f }

WebMock.disable_net_connect!(allow_localhost: true)

RSpec.configure do |c|
  c.include WebMockStubs
end
