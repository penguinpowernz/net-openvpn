module Net
  module Openvpn
    module Generators
      module Keys
        class Base
          def initialize(name, props)
            @name = name
            @props = Openvpn.props + props

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

          # Returns true if the generated keys are valid or false if not
          def valid?
            latest_valid = nil

            # read the index file
            File.read(Openvpn.config[:key_index]).each_line do |line|
              next if line.nil?
              if line.include? @name and line =~ /^V/ # find the latest valid line
                latest_valid = line
              end
            end

            #  line found? then there is no valid key
            return false if latest_valid.nil?

            # get the pem number and build the paths
            pem = latest_valid.split("\t")[3]
            pem_path = "#{Openvpn.config[:key_path]}/#{pem}.pem"
            crt_path = "#{Openvpn.config[:key_path]}/#{@name}.crt"

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

            !valid? || raise Openvpn::Errors::CertificateRevocation, "Certificates were still valid after being revoked"

            true
          end

        end
      end
    end
  end
end