# Net-Openvpn

Net-Openvpn is a gem for configuring a local OpenVPN installation.

## Requirements

* openvpn
* easy-rsa

You can install these on Debian based systems by running this command:

```sh
apt-get install openvpn easy-rsa
```

Sometimes `easy-rsa` is packaged with `openvpn` so if you can't find the `easy-rsa` package anywhere have a
look in `/usr/share/doc/openvpn/examples` for the `easy-rsa` folder.  Then you can just globally override 
the property for `:easy_rsa`  (see below).

## Usage

### Server configuration

Modifying the config for a server (config file will be called `auckland-office.conf`):

```ruby
server = Net::Openvpn.server("auckland-office")
server.set :port, 1194
server.save
```

### Host Configuration (read: client-config-directive)

**Technically this is a client**, and I should have named it `Client` instead of `Host`, but I don't want to break existing apps using this gem.  So I aliased `Net::Openvpn::Client` to `Net::Openvpn::Host` so you can use the former.  However, objects returned by initialization will still be of the type `Net::Openvpn::Host`.

This is how you set the IP address of a VPN host with the hostname `optimus`:

```ruby
host = Net::Openvpn.host("optimus")
host.ip = 10.8.0.24
host.network = 10.8.0.0
host.save
```

You can also use a ActiveModel kind of initialization to allow you to create a host in one fell swoop:

```ruby
Net::Openvpn::Host.new("optimus", ip: "10.8.0.10", network: "10.8.0.0").save
```

This would create a file at `/etc/openvpn/ccd/optimus` containing the following:

```
ifconfig-push 10.8.0.24 10.8.0.0
```

So that any host connecting to the VPN with a hostname of `optimus` get assigned `10.8.0.24`.

There are also some other handy methods on the host object:

```ruby
host.file     # where is the file kept?
host.remove   # get rid of the host (delete the file)
host.exist?   # does the file exist?
host.new?     # has it been saved yet?
host.ip       # what is the ip of this host
host.network  # what is the network of this host
```

## Generating certificates and keys

### Default key properties

You will probably need to set key properties when generating keys.  There are some
defaults already set and they can be seen by calling the `default` method on the
`Properties` module (but are listed here for brevity):

```ruby
> Net::Openvpn::Generators::Keys::Properties.default
{
  :easy_rsa => "/usr/share/easy-rsa", 
  :openssl => "openssl", 
  :pkcs11tool => "pkcs11-tool", 
  :grep => "grep", 
  :key_dir => "/etc/openvpn/keys",
  :key_dir_owner => "root",
  :key_dir_group => "root",
  :key_dir_permission => "700",
  :pkcs11_module_path => "changeme", 
  :pkcs11_pin => 1234, 
  :key_size => 1024, 
  :ca_expire => 3650, 
  :key_expire => 3650, 
  :key_country => "US", 
  :key_province => "CA", 
  :key_city => "SanFrancisco", 
  :key_org => "Fort-Funston", 
  :key_email => "me@myhost.mydomain", 
  :key_cn => "changeme", 
  :key_name => "changeme", 
  :key_ou => "changeme", 
  :key_config => "/usr/share/easy-rsa/openssl-1.0.0.cnf",
  :key_index => "/etc/openvpn/keys/index.txt"
}
```

### Overriding key properties globally

Key properties can be overidden by creating the file: `/etc/openvpn/props.yml`

In this way you can override the default `openssl.cnf` file, the location of your 
`easy-rsa` folder, key size or any properties listed above!

```yml
---
:easy_rsa: /usr/share/doc/openvpn/examples/easy-rsa/2.0
:key_config: /path/to/openssl.cnf
:key_dir: /path/to/generated/keys
```

Properties set in the YAML file will override the default ones.

### Overriding key properties at generation time

You can also provide key properties when you do the actual generation of the keys as
described below.  These properties will override properties set in the YAML file.

### Clients

```ruby
keys = Net::Openvpn::Generators::Keys::Client.new(name)
keys.generate
keys.exist?  # returns true if the key files exist
keys.valid?  # returns true if the keys are valid in the index
```

You should now have the following files present:

Revoke the keys like so:

```ruby
keys = Net::Openvpn::Generators::Keys::Client.new(name)
keys.revoke!
keys.valid?  # returns false
```

## Rails Permissions

If you are running rails and you want to give the rails user access, you could do it like this:

```sh
groupadd openvpn
chown root.openvpn /etc/openvpn -R
chmod ug+rwx /etc/openvpn -R
chmod o-rwx /etc/openvpn -R
cd /etc/openvpn
chmod g-rwx easy-rsa *.key *.crt *.pem
usermod -aG openvpn rails-app-user
```
