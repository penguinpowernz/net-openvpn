require 'net/openvpn'
require 'fakefs/spec_helpers'
require 'yaml'

RSpec.configure do |config|
  config.include FakeFS::SpecHelpers, fakefs: true
end

def setup_overrides(path)

  overrides = {
    key_dir_owner: ENV["USER"],
    key_dir_group: ENV["USER"],
    key_permission: 0770,
    key_size: 384 # tiny key to speed up the tests
  }

  File.open("#{path}/props.yml", "w") { |f| f.write overrides.to_yaml }

end

def stub_basepath
  Net::Openvpn.stub(:basepath) do |path|
    path = "/#{path}" unless path.nil?
    "/tmp/openvpn#{path}"
  end
end

def setup_filesystem(type)
  case type
  when :fake
    FakeFS::FileSystem.clone "/usr/share/easy-rsa"
    FileUtils.mkdir_p "/etc/openvpn"
    setup_overrides "/etc/openvpn"
  when :tmp
    FileUtils.mkdir_p "/tmp/openvpn"
    setup_overrides "/tmp/openvpn"
    stub_basepath
  end
end

def destroy_filesystem(type)
  FileUtils.rm_rf "/tmp/openvpn"
end