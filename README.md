# Wireguard VPN Server Setup Script

<img src="https://raw.githubusercontent.com/sreejithag/wireguard_vpn_server_setup_script/main/assets/wireguard.png" > <br/>

Script can be used to install and configure wiregurad VPN server in an Ubuntu cloud VM.

## Requirements

1. Ubuntu server
2. Allowed UDP port 51820

## Installation

Script can accepts 2 arguments 

1. Number of clients (Default is 1 if not provided)
2. Network interface name (Can be skipped provide it if the script fails to auto detect it correctly)

Script will install and configure the wireguard and genarte client configuration files which can be used in the wireguard clinet application to connect to the server.

### Steps

```
1. wget https://bit.ly/wireguard-script -O wireguard.sh
2. bash wireguad.sh <number of clients> <network interface name>
```

**Example** `bash wireguard.sh 2 `

This will genarate 2 client config files client1.conf and client2.conf

