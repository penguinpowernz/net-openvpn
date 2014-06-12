module Net
  module Openvpn
    module Generators
      module Keys
        class Directory

          def initialize(**props)
            @props = Openvpn.props.merge props
          end

          def setup?
            File.directory?(@props[:key_dir]) and
            File.exist?(@props[:key_index]) and
            File.exist?("#{@props[:key_dir]}/serial")
          end

          # Sets up the directory where keys are to be generated.
          # Also creates the serial and index.txt used by the pkitool
          # that comes with easy-rsa
          def setup

            FileUtils.mkdir_p @props[:key_dir] unless
              File.directory? @props[:key_dir]

            FileUtils.cd(@props[:key_dir]) do
              FileUtils.touch @props[:key_index]
              File.open("serial", "w") {|f| f.write "01" }
            end

            FileUtils.chown_R(
              @props[:key_dir_owner],
              @props[:key_dir_group],
              @props[:key_dir]
            )

            FileUtils.chmod_R(
              @props[:key_dir_permission],
              @props[:key_dir]
            )

          end

        end
      end
    end
  end
end