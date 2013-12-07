module Net
  module Openvpn
    class Server

      def initialize(name)
        @name = name
        load if exists?
      end

      def load
        @config = Net::Openvpn::Parser::ServerConfig.parse(path)
      end

      def get(key)
        @config[key]
      end

      def set(key, value)
        @config[key] = value
      end

      def path
        Net::Openvpn.basepath "#{@name}.conf"
      end

      def exists?
        File.exists? path
      end

      def save
        Net::Openvpn::Parser::ServerConfig.save(path, @config)
      end

    end
  end
end