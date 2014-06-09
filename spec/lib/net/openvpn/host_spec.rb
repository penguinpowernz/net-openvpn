require 'spec_helper'
require 'fileutils'

describe Net::Openvpn::Host, fakefs: true do
  let(:hostname) { "test" }
  let(:network)  { "10.8.0.0" }
  let(:ip)       { "10.8.0.10" }
  subject(:host) { Net::Openvpn::Host.new(hostname, ip: ip, network: network) }

  before(:each) do
    FileUtils.mkdir_p("/etc/openvpn/ccd")
  end

  it "should create a host client configuration" do
    expect(host).to_not exist
    host.save
    expect(host).to exist
  end

  it "should remove a host client configuration" do
    host.save
    expect(host).to exist
    host.remove
    expect(host).to_not exist
  end

  it "should have the correct info in the CCD file" do
    host.save
    expect(File.read host.file).to include ip
    expect(File.read host.file).to include network
  end

  it "should be new when it hasn't been saved" do
    expect(host).to be_new
  end

  it "should not be new when it has been saved" do
    host.save
    expect(host).to_not be_new
  end

  it "should assign the ip" do
    ip = "10.10.0.10"
    host.ip = ip
    expect(host.ip).to eq ip
  end

  it "should assign the network" do
    network = "10.10.0.0"
    host.network = network
    expect(host.network).to eq network
  end

  it "should save the ip to the file" do
    host.save
    ip = "10.10.0.10"
    host.ip = ip
    host.save
    expect(File.read host.file).to include ip
  end

  it "should save the network to the file" do
    host.save
    network = "10.10.0.0"
    host.network = network
    host.save
    expect(File.read host.file).to include network
  end

  it "should return the name of the host" do
    expect(host.name).to eq hostname
  end

  it "should return the ip of the host" do
    expect(host.ip).to eq ip
  end

  it "should return the network of the host" do
    expect(host.network).to eq network
  end

end