# Wireguard VPN Server Setup Script

<img src="https://raw.githubusercontent.com/sreejithag/wireguard_vpn_server_setup_script/main/assets/wireguard.png" > <br/>

Script can be used to install and configure wiregurad VPN server in an Ubuntu cloud VM.

## Requirements

1. Ubuntu server
2. Allowed UDP port 51820

## Installation

Script can accepts 2 arguments 

1. Number of clients (Default is 1 if not provided)
2. Network interface name (Can be skipped provide it if script detects fails to auto detect it correctly)
