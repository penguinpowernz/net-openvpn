module Net
  module Openvpn
    module Generators
      module Keys
        class Client < Base

          def initialize(name)
            super(name)
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
            FileUtils.cd(Openvpn.config[:keygen_path]) do
              system ". ./vars && ./#{build_script} #{@name}"
            end

            exist? || raise Openvpn::Errors::KeyGeneration, "Keys do not exist"
            valid? || raise Openvpn::Errors::KeyGeneration, "keys are not valid"

            true
          end

          # Returns an array containing the paths to the generated keys
          def filepaths
            [
              "#{Openvpn.config[:key_path]}/#{@name}.key",
              "#{Openvpn.config[:key_path]}/#{@name}.crt"
            ]
          end

        end
      end
    end
  end
end