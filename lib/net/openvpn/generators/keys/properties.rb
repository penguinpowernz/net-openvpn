module Net
  module Openvpn
    module Generators
      module Keys
        module Properties
          class << self

            # Returns the properties loaded from a YAML file
            # located in /etc/openvpn/props.yml
            def yaml
              return {} unless File.exist? Openvpn.basepath "props.yml"
              YAML.load(File.read(Openvpn.basepath "props.yml"))
            end

            # Returns the default set of properties as per the easy-rsa
            # 'vars' script
            def default
              props = {
                easy_rsa: "/usr/share/easy-rsa",
                openssl: "openssl",
                pkcs11tool: "pkcs11-tool",
                grep: "grep",
                key_dir: "#{Openvpn.basepath}/keys",
                pkcs11_module_path: "dummy",
                pkcs11_pin: "dummy",
                key_size: 1024,
                ca_expire: 3650,
                key_expire: 3650,
                key_country: "US",
                key_province: "CA",
                key_city: "SanFrancisco",
                key_org: "Fort-Funston",
                key_email: "me@myhost.mydomain",
                key_cn: "changeme",
                key_name: "changeme",
                key_ou: "changeme",
                pkcs11_module_path: "changeme",
                pkcs11_pin: 1234
              }

              props[:key_config] = "#{props[:easy_rsa]}/openssl-1.0.0.cnf"
              props[:key_index]  = "#{props[:key_dir]}/index.txt"

              props
            end

            alias_method :defaults, :default # POLS


            # Ensures that all the required properties are available to
            # stop the easy-rsa scripts having a cry
            def validate!(props)

            end

          end
        end
      end
    end
  end
end