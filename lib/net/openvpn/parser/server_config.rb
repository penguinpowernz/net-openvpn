module Net
  module Openvpn
    module Parser
      module ServerConfig
        class << self

          def parse(text)
            config = {}

            text.each_line do |line|
              next if line =~ /^$/
              parts = line.split(" ")
              key = parts.first
              value = parts[1..parts.size].join(" ")
              config[key.to_sym] = value
            end

            config
          end

          def generate(config)
            text = ""
            config.each do |key, value|
              text.concat "#{key} #{value}\n"
            end
            text
          end

        end
      end
    end
  end
end