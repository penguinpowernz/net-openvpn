require 'fileutils'

require 'net/openvpn/server'
require 'net/openvpn/host'
require 'net/openvpn/errors'
require 'net/openvpn/client_config'
require 'net/openvpn/parser/server_config'

require 'net/openvpn/generators/keys/base'
require 'net/openvpn/generators/keys/directory'
require 'net/openvpn/generators/keys/client'
require 'net/openvpn/generators/keys/server'
require 'net/openvpn/generators/keys/properties'
require 'net/openvpn/generators/keys/authority'

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

      def generator(type)
        case type
        when :client
          Net::Openvpn::Generators::Keys::Client
        when :server
          Net::Openvpn::Generators::Keys::Server
        when :directory
          Net::Openvpn::Generators::Keys::Directory
        when :authority
          Net::Openvpn::Generators::Keys::Authority
        end
      end

      # Returns the default key properties merged with
      # the properties stored in /etc/openvpn/props.yml
      def props
        props = Openvpn::Generators::Keys::Properties

        props.default.merge props.yaml
      end

    end
  end
end
