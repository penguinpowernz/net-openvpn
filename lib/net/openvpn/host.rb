module Net
  module Openvpn
    class Host

      def initialize(hostname, **params)
        @hostname = hostname
        @config = Net::Openvpn::ClientConfig.new(@hostname)

        params.each do |key, value|
          self.send("#{key}=".to_sym, value)
        end
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