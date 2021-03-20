# Wireguard VPN Server Setup Script

<img src="https://raw.githubusercontent.com/sreejithag/wireguard_vpn_server_setup_script/main/assets/wireguard.png" > <br/>

The script can be used to install and configure wiregurad VPN server in an Ubuntu cloud VM.

## Requirements

1. Ubuntu server
2. Allowed UDP port 51820

## Installation

Script can accept 2 arguments 

1. Number of clients (Default is 1 if not provided)
2. Network interface name (Can be skipped provide it if the script fails to auto-detect it correctly)

The script will install and configure the wireguard and generate client configuration files which can be used in the wireguard client application to connect to the server.

### Steps

```
1. wget https://bit.ly/wireguard-script -O wireguard.sh
2. bash wireguad.sh <number of clients> <network interface name>
```

**Example** `bash wireguard.sh 2 `

This will generate 2 client config files client1.conf and client2.conf

### Adding more clients 

More clients can be added simply by using the add_clients.sh script.

This script accepts one optional argument

1. Number of clients (optional default is 1)

```
1. wget https://bit.ly/wireguard-add -O add_clients.sh 
2. bash add_clients.sh <number of clients>
```
**Example** `bash add_clients.sh 2`

This will add 2 more clients and generate client config files client3.conf and client4.conf (if client 1 and 2 already exists)


## 🤝 Contributing
If you like to add anything extra or found a bug fix please raise a pull request.

## 📣 Feedback
- ⭐ This repository if this project helped you! :wink:
- Create An [🔧 Issue](https://github.com/sreejithag/wireguard_vpn_server_setup_script/issues) if you need help / found a bug

