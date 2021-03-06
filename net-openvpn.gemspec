#coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'net/openvpn/version'

Gem::Specification.new do |spec|
  spec.name          = "net-openvpn"
  spec.version       = Net::Openvpn::VERSION
  spec.authors       = ["Robert McLeod"]
  spec.email         = ["robert@penguinpower.co.nz"]
  spec.description   = %q{Net-Openvpn is an openvpn library for configuring a local OpenVPN service}
  spec.summary       = %q{Local OpenVPN configurator}
  spec.homepage      = "https://github.com/penguinpowernz/net-openvpn"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "fakefs"
  spec.add_development_dependency "serialport"

end

