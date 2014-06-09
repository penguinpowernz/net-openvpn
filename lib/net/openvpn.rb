require 'net/openvpn/server'
require 'net/openvpn/host'
require 'net/openvpn/client_config'
require 'net/openvpn/parser/server_config'

require 'net/openvpn/generators/keys/base'
require 'net/openvpn/generators/keys/client'
require 'net/openvpn/generators/keys/server'


module Net
  module Openvpn
    class << self

      def basepath(path="")
        path = "/#{path}" unless path.empty?
        "/etc/openvpn#{path}"
      end

      def ccdpath(path="")
        path = "/#{path}" unless path.empty?
        basepath "ccd#{path}"
      end

      def host(hostname)
        Net::Openvpn::Host.new(hostname)
      end

      def server(name)
        Net::Openvpn::Server.new(name)
      end

    end
  end
end
