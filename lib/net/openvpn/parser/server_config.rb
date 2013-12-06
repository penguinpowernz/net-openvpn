module Net
  module Openvpn
    module Parser
      module ServerConfig
        class << self

          def parse(path)
            config = {}

            File.readlines(path).each_line do |line|
              next if line =~ /^$/
              parts = line.split(" ")
              key = parts.first
              value = parts[1..parts.size].join(" ")
              config[key.to_sym] = value
            end

            config
          end

          def save(path, config)
            File.open(path, "w") do |f|
              config.each do |key, value|
                f.puts "#{key} #{value}"
              end
            end
          end

        end
      end
    end
  end
end