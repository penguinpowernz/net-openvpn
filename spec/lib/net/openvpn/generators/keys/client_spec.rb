require 'spec_helper'

describe Net::Openvpn::Generators::Keys::Client do
  subject(:client) { Net::Openvpn::Generators::Keys::Client.new(name, props) }
  let(:directory)  { Net::Openvpn::Generators::Keys::Directory.new }
  let(:authority)  { Net::Openvpn::Generators::Keys::Authority }
  let(:name)       { "test" }
  let(:props)      { {} }

  before(:each) { setup_filesystem(:tmp) }
  after(:each)  { destroy_filesystem(:tmp) }

  context "when a client has not been generated" do
    it "should not exist" do
      expect(client).to_not exist
    end 
  end

  context "when the key directory has not been generated" do

    it "should raise an error" do
      expect { client.generate }.to raise_error(
        Net::Openvpn::Errors::KeyGeneration,
        "Key directory has not been generated yet"
      )
    end

  end

  context "when the key directory has been generated" do
    before(:each) { directory.generate }

    context "and the authority has not been generated" do
      before(:each) { expect(authority).to_not exist }

      it "should raise an error" do
        expect { client.generate }.to raise_error(
          Net::Openvpn::Errors::KeyGeneration,
          "Certificate Authority has not been created"
        )
      end
    end

    context "and the authority has been generated" do
      before(:each) do
        authority.new.generate
        expect(authority).to exist
      end

      context "and the client has not been generated" do
        it "should not exist" do
          expect(client).to_not exist
        end

        it "should not be valid" do
          expect(client).to_not be_valid
        end
      end

      context "and the client has been generated" do
        before(:each) do
          client.generate
        end

        it "should exist" do
          expect(client).to exist
        end

        it "should be valid" do
          expect(client).to be_valid
        end
      end
    end

  end
end