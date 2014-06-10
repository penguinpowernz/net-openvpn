module Net
  module Openvpn
    module Generators
      module Keys
        class Authority

          def initialize(props)
            @props = Openvpn.props.merge props
          end

          def generate
            FileUtils.cd(@props[:easy_rsa]) do
              system "#{cli_prop_vars} ./pkitool --initca"
              system "#{cli_prop_vars} ./build-dh"
            end
          end

          def cli_prop_vars
            Properties.to_cli_vars(@props)
          end

        end
      end
    end
  end
end