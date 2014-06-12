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
            Authority.new.exist? or raise Errors::KeyGeneration, "Certificate Authority has not been created"
            @key_dir.setup?  or raise Errors::KeyGeneration, "Key directory has not been setup yet"

            revoke! if exist? and valid?

            FileUtils.cd(@props[:easy_rsa]) do
              system "#{cli_prop_vars} ./pkitool #{@name}"
            end

            exist? or raise Errors::KeyGeneration, "Keys do not exist"
            valid? or raise Errors::KeyGeneration, "keys are not valid"

            true
          end

          # Returns an array containing the paths to the generated keys
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