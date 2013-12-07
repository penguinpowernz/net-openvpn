#coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "net-openvpn"
  spec.version       = "0.1"
  spec.authors       = ["Robert McLeod"]
  spec.email         = ["robert@penguinpower.co.nz"]
  spec.description   = %q{Net-Openvpn is an openvpn library for configuring a local OpenVPN service}
  spec.summary       = %q{Local OpenVPN configurator}
  spec.homepage      = "https://github.com/penguinpowernz/net-openvpn"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.require_paths = ["lib"]
end

