module Net
  module Openvpn
    class Server

      def initialize(name)
        @name = name
        load if exists?
      end

      def load
        @config = Net::Openvpn::Parser::ServerConfig.parse(File.read(path))
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
        text = Net::Openvpn::Parser::ServerConfig.generate(@config)
        File.open(path, "w") do |f|
          f.puts text
        end
      end

    end
  end
end