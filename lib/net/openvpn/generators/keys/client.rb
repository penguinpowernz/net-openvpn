module Net
  module Openvpn
    module Generators
      module Keys
        class Client < Base

          def initialize(name, **props)
            super(name, props)
            @build_script = "build-key"
          end
          
          # Generates the certificates for a VPN client
          #
          # Raises `Net::Openvpn::Errors::KeyGeneration` if the key files were
          # not created or are not valid keys according to the keystore
          #
          # Returns true if the generation was successful
          #
          def generate
            revoke! if exist? and valid?
            
            FileUtils.cd(@props[:easy_rsa]) do
              system "#{cli_prop_vars} ./#{build_script} #{@name}"
            end

            exist? or raise Openvpn::Errors::KeyGeneration, "Keys do not exist"
            valid? or raise Openvpn::Errors::KeyGeneration, "keys are not valid"

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