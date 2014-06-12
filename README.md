# Net-Openvpn

Net-Openvpn is a gem for configuring a local OpenVPN installation.

## Requirements

You will need these packages.

* openvpn
* easy-rsa

You can install these on Debian based systems by running this command:

```sh
apt-get install openvpn easy-rsa
```

### Easy RSA

Easy RSA is only needed for key generation, so if you are not doing any of that then you don't need to worry.

Sometimes `easy-rsa` is packaged with `openvpn` so if you can't find the `easy-rsa` package anywhere have a
look in `/usr/share/doc/openvpn/examples` for the `easy-rsa` folder.

```sh
sudo cp /usr/share/doc/openvpn/examples/easy-rsa/2.0 /usr/local/easy-rsa
```

You could also clone the `release/2.x` branch from the `easy-rsa` repo at `https://github.com/OpenVPN/easy-rsa.git` then copy the `easy-rsa/2.0` folder to wherever you want.

```sh
git clone https://github.com/OpenVPN/easy-rsa.git -b release/2.x
sudo cp easy-rsa/easy-rsa/2.0 /usr/local/easy-rsa
```

Then you can just globally override the property for `:easy_rsa` to specify the location of the scripts folder (see below).

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

**WARNING: This functionality is a little bit experimental at the moment, I am sure there are bugs present which would be found with more specs.**

The goal is to build these generators into the Host (read: Client) and Server classes above so you can do something like `server.generate_keys!`.

### Default key properties

You will probably need to set key properties when generating keys.  There are some
defaults already set and they can be seen by calling `Properties#default` (but are listed here for brevity):

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

Properties set in the YAML file will override the default ones.  You can see which properties are specified in the YAML file by checking the `Properties#yaml`.

```ruby
> Net::Openvpn::Generators::Keys::Properties.default
{
  :easy_rsa => "/usr/share/doc/openvpn/examples/easy-rsa/2.0",
  :key_config => "/path/to/openssl.cnf",
  :key_dir => "/path/to/generated/keys"
}
```

But really you should use `Net::Openvpn#props` to get properties because that will merge the defaults with the properties from the YAML file, the latter overriding keys in the former.

### Overriding key properties at generation time

You can also provide key properties when you do the actual generation of the keys as
described below.  These properties will override properties set in the YAML file.

These properties can be supplied directly to the `Authority`, `Client`, `Server` and `Directory` classes in the `Generators::Keys` module as arguments to the `new` method:

```ruby
Net::Openvpn::Generators::Keys::Directory.new key_dir_permission: 0770

Net::Openvpn::Generators::Keys::Authority.new key_size: 8192      # this will take hours lol

Net::Openvpn::Generators::Keys::Client.new(
  "fred",
  key_country: "Switzerland",
  key_province: "Romandy",
  key_city: "Geneva",
  key_email: "fred@example.com"
)

Net::Openvpn::Generators::Keys::Server.new(
  "norvpn01",
  key_country: "Norway",
  key_province: "Ostlandet",
  key_city: "Oslo",
  key_email: "admin@example.com"
)
```

### Key Directory

To start with the first thing you will need to do is setup the key directory.  This can be done with the following line:

```ruby
# keys = Net::Openvpn.generator(:directory).new
key_dir = Net::Openvpn::Generators::Keys::Directory.new 
key_dir.generate
key_dir.exist?  # check that it worked
```

This should generate the following files/folders:

* /etc/openvpn/keys
* /etc/openvpn/keys/index.txt
* /etc/openvpn/keys/serial

### Certificate Authority

You will also need to generate the certificate authority and DH key like so.

```ruby
# keys = Net::Openvpn.generator(:authority).new
ca = Net::Openvpn::Generators::Keys::Authority.new
ca.generate
ca.exist?
```

This should generate the following files/folders:

* /etc/openvpn/keys/ca.crt
* /etc/openvpn/keys/ca.key
* /etc/openvpn/keys/dh1024.pem

### Servers

```ruby
# keys = Net::Openvpn.generator(:server).new("swzvpn04")
keys = Net::Openvpn::Generators::Keys::Server.new("swzvpn04")
keys.generate
keys.exist?  # returns true if the key files exist
keys.valid?  # returns true if the keys are valid in the index
```

This should generate the following files/folders:

* /etc/openvpn/keys/swzvpn04.key
* /etc/openvpn/keys/swzvpn04.crt

### Clients

```ruby
# keys = Net::Openvpn.generator(:client).new("fred")
keys = Net::Openvpn::Generators::Keys::Client.new("fred")
keys.generate
keys.exist?  # returns true if the key files exist
keys.valid?  # returns true if the keys are valid in the index
```

This should generate the following files/folders:

* /etc/openvpn/keys/fred.key
* /etc/openvpn/keys/fred.crt

Revoke the keys like so (UNTESTED!):

```ruby
keys = Net::Openvpn::Generators::Keys::Client.new("fred")
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

Then override the following properties in your `/etc/openvpn/props.yml` file:

```yaml
---
:key_dir_group: "openvpn"
:key_dir_permission: 0700
```
