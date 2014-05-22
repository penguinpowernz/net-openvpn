require 'fileutils'

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
        @network = matches[2]
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

      def network=(network)
        @network = network
      end

      def validate!
        raise ArgumentError, "No IP set!" if @ip.nil? or @ip.empty?
        raise ArgumentError, "No network set!" if @network.nil? or @network.empty?
      end

      def remove
        return true if !File.exist? path
        FileUtils.rm path
      end

      def save
        validate!
        
        File.open(path, "w") do |f|
          f.puts "ifconfig-push #{@ip} #{@network}"
        end
      end

    end
  end
end