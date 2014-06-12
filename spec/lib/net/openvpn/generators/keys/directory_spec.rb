require 'spec_helper'

describe Net::Openvpn::Generators::Keys::Directory, fakefs: true do
  subject(:dir) { Net::Openvpn::Generators::Keys::Directory.new(props) }
  let(:props)   { {} }

  before(:each) { setup_filesystem(:fake) }

  it "should exist after generation" do
    dir.generate
    expect(dir).to exist
  end

  it "should create the key dir folder" do
    dir.generate
    expect(File.exist? "/etc/openvpn/keys").to be_true
  end

  context "when the key dir property is changed" do
    let(:props) { { key_dir: "/etc/openvpn/my_keys", key_index: "/etc/openvpn/my_keys/index.txt" } }
    it "should create the key dir folder" do
      dir.generate
      expect(File.exist? "/etc/openvpn/my_keys").to be_true
    end
  end

end