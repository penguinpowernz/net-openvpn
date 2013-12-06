module Net
  module Openvpn
    class ClientConfig

      def initialize(hostname)
        @hostname = hostname
        load if exists?
      end

      def load
        ccd = File.read(path)
        matches = ccd.match /ifconfig-push ([0-9\.]+) ([0-9\.]+)/
        @ip = matches[1]
        @subnet = matches[2]
      end

      def path
        Net::Openvpn.ccdpath @hostname
      end

      def exists?
        File.exists? path
      end

      def ip=(ip)
        @ip = ip
      end

      def subnet=(subnet)
        @subnet = subnet
      end

      def validate!
        raise ArgumentError, "No IP set!" if @ip.nil? or @ip.empty?
        raise ArgumentError, "No subnet set!" if @subnet.nil? or @subnet.empty?
      end

      def save
        validate!
        
        File.open(path, "w") do |f|
          f.puts "ifconfig-push #{@ip} #{@subnet}"
        end
      end

    end
  end
end