module Net
  module Openvpn
    module Generators
      module Keys
        class Base
          def initialize(name, props)
            @name = name
            @props = Openvpn.props.merge props
            @props[:key_cn] = @name

            Properties.validate! @props
          end
          
          def generate
            raise NotImplentedError
          end

          # Returns true if all the generated keys exist or false if not
          def exist?
            filepaths.each do |file|
              return false if !File.exist? file
            end
          end

          # Returns true if the generated keys are valid by checking
          # the key index and then checking the pemfile against the crt
          # file.
          def valid?
            # read the index file
            m = File.read(Openvpn.props[:key_index]).match /^V.*CN=#{@name}.*$/

            return false if m.nil?

            # get the pem number and build the paths
            pem = m[0].split("\t")[3]
            pem_path = "#{Openvpn.props[:key_dir]}/#{pem}.pem"
            crt_path = "#{Openvpn.props[:key_dir]}/#{@name}.crt"

            # Check the pem against the current cert for the name
            File.read(pem_path) == File.read(crt_path)
          end

          # Revokes the keys
          #
          # Returns true if the keys were revoked or false if the keys do
          # not exist or are not valid
          #
          # raises `Net::Openvpn::Errors::CertificateRevocation` if the key
          # failed to be revoked
          #
          def revoke!
            return false unless exist? and valid?

            FileUtils.cd(Openvpn.config[:keygen_path]) do
              output = `. ./vars && ./revoke-full #{mac}`
              raise Openvpn::Errors::CertificateRevocation, "Revoke command failed" if !output.include? "error 23" # error 23 means key was revoked
            end

            !valid? or raise Openvpn::Errors::CertificateRevocation, "Certificates were still valid after being revoked"

            true
          end

          private

          # Generates the variable string of key properties
          # to preceed easy-rsa script calls
          #
          # An example with just two properties:
          #
          #     EASY_RSA="/usr/share/easy-rsa" KEY_CN="fred" build-key ...
          #
          def cli_prop_vars
            Properties.to_cli_vars(@props)
          end

        end
      end
    end
  end
end