require 'spec_helper'

describe AppSpiderRails::Connection do
  let(:spec_auth_file) {"spec/config/auth.yml"}
  let(:bad_response)   { %q({"IsSuccess": false,"Reason": "I don't like you","ErrorMessage": "ouch"}) }
  let(:good_response)  { %q({"Token":"40224","IsSuccess":true,"Reason":null,"ErrorMessage":null}) }
  let(:support)        { AppSpiderRails::Support.new }
  let(:auth)           { support.load_authorization(spec_auth_file) }
  let(:user)           { AppSpiderRails::User.new(auth[:username], auth[:password]) }
  let(:body)           { { "name"=>"Sarah", "password"=>"dogs > cats" } }

  def stub_authenticate
    stub_request(
      :post,
      "http://example.com/test/AppSpiderEnterprise/rest/v1/Authentication/Login"
    ).with(
      body: {"name"=>"Sarah", "password"=>"dogs > cats"},
      headers: {
        'Accept'=>'*/*',
        'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
        'Content-Type'=>'application/x-www-form-urlencoded',
        'Host'=>'example.com',
        'User-Agent'=>'Ruby'
      }
    ).to_return(status: 200, body: yield, headers: {})
  end

  before do
    support.load_logger("logs/spec_logs.log")
    support.load_paths("spec/config/paths.yml")
  end

  describe "#authenticate!" do
    context "on success" do
      before do
        stub_authenticate { good_response }
      end

      it "will authenticate using configuration files" do
        connection = described_class.new(support, user: user)
        connection.authenticate!
        expect(connection.token).to eq("40224")
      end
    end

    context "on failure" do
      before do
        stub_authenticate { bad_response }
      end

      it "will raise an execption with a message" do
        connection = described_class.new(support, user: user)
        expect{
          connection.authenticate!
        }.to raise_error(AppSpiderRails::CannotAuthenticate, "ouch")
        expect(connection.token).to eq(nil)
      end
    end
  end

  context "HTTP calls" do
    describe "#get!" do
      let(:connection) { described_class.new(support, user: user) }

      before do
        stub_authenticate { good_response }
        connection.authenticate!
      end

      context "on success" do
        let(:http_response) { double("Net::HTTPResponse", body: "") }

        before do
          stub_request(
            :get,
            "http://%E3M%B6@example.com/test/AppSpiderEnterprise/rest/v1/Findings/GetVunlerabilities"
          ).with(
            headers: {
              'Accept'=>'*/*',
              'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
              'User-Agent'=>'Ruby'
            }
          ).to_return(status: 200, headers: {}, body: http_response.body)
        end

        it "will use the current users authenticated token to perform a get call against an API endpoint" do
          response = connection.get!("Findings/GetVunlerabilities")
          expect(response.successful?).to be_truthy
        end
      end

      context "on failure" do
        before do
          stub_request(
            :get,
            "http://%E3M%B6@example.com/test/AppSpiderEnterprise/rest/v1/Findings/GetVunlerabilities"
          ).with(
            headers: {
              'Accept'=>'*/*',
              'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
              'User-Agent'=>'Ruby'
            }
          ).to_return(status: 403, body: "", headers: {})
        end

        context "when not authenticated" do
          it "will return non 200" do
            response = connection.get!("Findings/GetVunlerabilities")
            expect(response.successful?).to be_falsey
          end
        end
      end
    end
  end
end
