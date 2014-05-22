# Net-Openvpn

Net-Openvpn is a gem for configuring a local OpenVPN installation.

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