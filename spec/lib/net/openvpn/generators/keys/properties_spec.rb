require 'spec_helper'

describe Net::Openvpn::Generators::Keys::Properties, fakefs: true do
  subject(:properties) { Net::Openvpn::Generators::Keys::Properties }
  subject(:defaults)   { properties.defaults }
  subject(:yaml)       { properties.yaml }

  context "when there is no props.yml file" do
    it "should have key size of 1024 from defaults" do
      expect(defaults[:key_size]).to eq 1024
    end

    it "should have empty hash from yaml" do
      expect(yaml).to be_empty
    end
  end

  context "when there is a props.yml file" do
    before(:each) { setup_filesystem(:fake) }

    it "should have key size of 384 from yaml" do
      expect(yaml[:key_size]).to eq 384
    end

    it "should have key size of 1024 from defaults" do
      expect(defaults[:key_size]).to eq 1024
    end
  end
end