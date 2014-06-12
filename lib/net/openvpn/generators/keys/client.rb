module Net
  module Openvpn
    module Generators
      module Keys
        class Client < Base

          def initialize(name, **props)
            super(name, props)
          end
          
          # Generates the certificates for a VPN client
          #
          # Raises `Net::Openvpn::Errors::KeyGeneration` if there were problems
          #
          # Returns true if the generation was successful
          #
          def generate
            @key_dir.exist?  or raise Errors::KeyGeneration, "Key directory has not been generated yet"
            Authority.exist? or raise Errors::KeyGeneration, "Certificate Authority has not been created"

            revoke! if valid?

            FileUtils.cd(@props[:easy_rsa]) do
              system "#{cli_prop_vars} ./pkitool #{@name}"
            end

            exist? or raise Errors::KeyGeneration, "Keys do not exist"
            valid? or raise Errors::KeyGeneration, "keys are not valid"

            true
          end

          # Returns an array containing the paths to the generated keys
          def filepaths
            [ key, certificate ]
          end

          def certificate
            "#{@props[:key_dir]}/#{@name}.crt"
          end

          def key
            "#{@props[:key_dir]}/#{@name}.key"
          end

        end
      end
    end
  end
end