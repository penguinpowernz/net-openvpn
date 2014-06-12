module Net
  module Openvpn
    module Generators
      module Keys
        class Server < Base

          def initialize(name, **props)
            super(name, props)
          end

          def generate
            @key_dir.exist?  or raise Errors::KeyGeneration, "Key directory has not been generated yet"
            Authority.exist? or raise Errors::KeyGeneration, "Certificate Authority has not been created"
            
            revoke! if valid?

            FileUtils.cd(@props[:easy_rsa]) do
              system "#{cli_prop_vars} ./pkitool --server #{@name}"
            end

            exist? or raise Openvpn::Errors::KeyGeneration, "Keys do not exist"
            valid? or raise Openvpn::Errors::KeyGeneration, "keys are not valid"

          end

          def filepaths
            [
              "#{@props[:key_dir]}/#{@name}.key",
              "#{@props[:key_dir]}/#{@name}.crt"
            ]
          end

        end
      end
    end
  end
end