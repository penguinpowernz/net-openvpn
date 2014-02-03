require 'spec_helper'
require 'fileutils'

describe Net::Openvpn::Host, fakefs: true do

  let(:network) { "10.8.0.0" }
  let(:ip)      { "10.8.0.10" }

  before(:each) do
    FileUtils.mkdir_p("/etc/openvpn/ccd")
  end

  def create_a_host
    host = Net::Openvpn.host("test")
    host.ip = ip
    host.network = network
    host.save
    host
  end

  it "should create a host client configuration" do
    create_a_host

    expect(File.exist?("/etc/openvpn/ccd/test")).to be_true
  end

  it "should remove a host client configuration" do
    host = create_a_host

    host.remove
    expect(File.exist?("/etc/openvpn/ccd/test")).to be_false
  end

  it "should have the correct info in the CCD file" do
    host = create_a_host

    expect(File.read("/etc/openvpn/ccd/test")).to include ip
    expect(File.read("/etc/openvpn/ccd/test")).to include network
  end

  it "should be new when it hasn't been saved" do
    host = Net::Openvpn.host("test")
    host.ip = ip
    host.network = network

    expect(host.new?).to be_true
  end

  it "should not be new when it has been saved" do
    host = create_a_host

    expect(host.new?).to be_false
  end

end