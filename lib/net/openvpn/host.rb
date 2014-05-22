module Net
  module Openvpn
    class Host

      attr_accessor :ip, :network
      attr_reader :hostname
      alias_method :name, :hostname

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

      def file
        @config.path
      end

      def path
        @config.path
      end

      def save
        @config.ip = ip
        @config.network = network
        @config.save
      end

      def remove
        @config.remove
      end

      def new?
        !@config.exists?
      end

      def exist?
        @config.exists?
      end

    end
  end
end