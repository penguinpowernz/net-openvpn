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

This is how you set the IP address of a VPN host with the hostname `optimus`:

```ruby
host = Net::Openvpn.host("optimus")
host.ip = 10.8.0.24
host.network = 10.8.0.0
host.save
```

This would create a file at `/etc/openvpn/ccd/optimus` containing the following:

```
ifconfig-push 10.8.0.24 10.8.0.0
```

So that any host connecting to the VPN with a hostname of `optimus` get assigned `10.8.0.24`.

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