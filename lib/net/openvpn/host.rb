module Net
  module Openvpn
    class Host

      def initialize(hostname)
        @hostname = hostname
        @config = Net::Openvpn::ClientConfig.new(@hostname)
      end

      def generate_key

      end

      def generate_ovpn

      end

      def ip=(ip)
        @config.ip = ip
      end

      def subnet=(subnet)
        @config.subnet = subnet
      end

      def save
        @config.save
      end

    end
  end
end