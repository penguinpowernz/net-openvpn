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

      def network=(network)
        @config.network = network
      end

      def save
        @config.save
      end

      def remove
        @config.remove
      end

      def new?
        !@config.exists?
      end

    end
  end
end