require 'spec_helper'

describe AppSpiderRails::Connection do
  let(:support)        { AppSpiderRails::Support.new }
  let(:auth)           { support.load_authorization(auth_file) }
  let(:user)           { AppSpiderRails::User.new(auth[:username], auth[:password]) }

  before do
    support.load_logger(log_file)
    support.load_paths(path_file)
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
end
