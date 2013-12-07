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