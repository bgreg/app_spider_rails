require 'spec_helper'
require 'app_spider_rails/base'
require 'app_spider_rails/connection'
require 'app_spider_rails/user'

describe AppSpiderRails::Connection do
  let(:spec_auth_file) {"spec/config/auth.yml"}
  let(:headers) {
    {
      'Accept'=>'*/*',
      'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
      'Content-Type'=>'application/x-www-form-urlencoded',
      'Host'=>'appspider.com',
      'User-Agent'=>'Ruby'
    }
  }
  let(:servername) { "http://appspider.com/" }
  let(:api_url)    { "AppSpiderEnterprise/rest/v1/Authentication/Login" }

  def web_mock_stub(type, body, response)
    stub_request(type, "#{servername}#{api_url}")
      .with( body: body, headers: headers)
      .to_return(response)
  end

  context "initializing a new connection" do
    describe "#new" do
      let(:auth) { AppSpiderRails.load_authorization(spec_auth_file) }
      let(:user) { AppSpiderRails::User.new(auth[:username], auth[:password]) }
      let(:body) { { "name"=>"Sarah", "password"=>"dogs > cats" } }
      let(:good_response) {
        {
          status: 200,
          body: %q({"Token":"40224","IsSuccess":true,"Reason":null,"ErrorMessage":null}),
          headers: {}
        }
      }

      it "will authenticate using configuration files" do
        web_mock_stub(:post, body, good_response)
        connection = described_class.new(servername)
        connection.authenticate(user)
      end
    end
  end

  describe "#build_from" do
    it "can take any config file and build a connection object" do
      connection = described_class.build_from(spec_auth_file)
      expect(connection.uri).to eq("http://www.example.com/test/AppSpiderEnterprise/rest/v1/")
    end
  end
end
