
require 'spec_helper'

describe AppSpiderRails::Http do
  describe "#get!" do
    let(:connection) { AppSpiderRails::Connection.new(support, user: user) }
    let(:support)    { AppSpiderRails::Support.new }
    let(:user)       { AppSpiderRails::User.new(auth[:username], auth[:password]) }
    let(:auth)       { support.load_authorization(auth_file) }

    before do
      support.load_logger(log_file)
      support.load_paths(path_file)
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
        response = described_class.new.get!("Findings/GetVunlerabilities", connection)
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
          response = described_class.new.get!("Findings/GetVunlerabilities", connection)
          expect(response.successful?).to be_falsey
        end
      end
    end
  end
end
