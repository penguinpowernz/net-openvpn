module Net
  module Openvpn
    module Generators
      module Keys
        class Authority < Base

          def initialize(name, **props)
            super(name, props)
          end

          def generate
            raise Errors::KeyGeneration, "Authority already exists!" if exist?

            setup unless setup?

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

        end
      end
    end
  end
end