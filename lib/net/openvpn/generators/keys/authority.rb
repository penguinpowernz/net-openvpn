module Net
  module Openvpn
    module Generators
      module Keys
        class Authority < Base

          def initialize(**props)
            super(nil, props)
          end

          def generate
            @key_dir.exist? or raise Errors::KeyGeneration, "Key directory has not been generated yet"
            !exist?         or raise Errors::KeyGeneration, "Authority already exists!"

            FileUtils.cd(@props[:easy_rsa]) do
              system "#{cli_prop_vars} ./pkitool --initca"
              system "#{cli_prop_vars} ./build-dh"
            end

            true
          end

          def filepaths
            [
              "#{@props[:key_dir]}/ca.key",
              "#{@props[:key_dir]}/ca.crt",
              "#{@props[:key_dir]}/dh#{@props[:key_size]}.pem"
            ]
          end

          def self.exist?
            Authority.new.exist?
          end

        end
      end
    end
  end
end