echo "==================================================================================="
echo "                             Wireguard Setup                                       "
echo "==================================================================================="
echo""


echo "==================================================================================="
echo ""
if [ -z "$1" ];
then

  n_clients=1

else
    n_clients=$1

fi

echo "Number of Clinets $n_clients (run add_clients.sh script to add more) "
echo ""




ip=`wget -qO- ifconfig.me/ip`

if [ -z "$ip" ];
then
    
    echo "`tput setaf 1`Server public IP autodetect failed please add the public IP in client config files `tput sgr0`"
    echo ""

else
    echo "Public IP of server detected as $ip"
    echo ""
    
fi


if [ -z "$2" ];
then
    interface=`ip -o -4 route show to default | awk '{print $5}'`
else
    interface=$2
fi


if [ -z "$interface" ];
then
    echo "`tput setaf 1`Network interface auto detect failed please provide it as argument and rerun the script `tput sgr0`"
    echo ""
    echo "==================================================================================="
        exit 1
else
        echo "Network intertace auto detected as $interface"
    echo ""
    echo "==================================================================================="

fi



echo "==================================================================================="
echo ""

if [ `wg-quick 2> /dev/stdout  | grep not | wc -l` -ne 0  ]
then
    echo "Installing wireguard-tools"

    sudo apt install -y  wireguard-tools

    echo ""
    echo "==================================================================================="
else
    echo "`tput setaf 2`Wireguard-tools already installed continuing with configuration `tput sgr0`"
    echo ""
    echo "==================================================================================="
fi



echo ""
echo "Wireguard Configuration"
echo "==================================================================================="
echo ""

if [ `wg-quick 2> /dev/stdout  | grep not | wc -l` -ne 1 ]
then


    echo "Stopping the wg0 interface if already running"
    echo ""

    sudo wg-quick down wg0 2> /dev/null

    wg genkey | tee server_private_key | wg pubkey > server_public_key

    echo "Server Keys generated `tput setaf 2`✓ `tput sgr0`"
    echo ""

    for n in $(seq 1 $n_clients );
    do
        wg genkey | tee client${n}_private_key | wg pubkey > client${n}_public_key
        echo "Client${n} Keys genarated `tput setaf 2`✓ `tput sgr0` "
        echo ""     
    done

    
    echo "Writing to wg0.conf and generating client config files"
    echo ""

    echo "
    [Interface]
    Address = 10.200.200.1/24
    MTU = 1440
    ListenPort = 51820
    PrivateKey = `cat server_private_key`
    PostUp   = iptables -A FORWARD -i %i -j ACCEPT; iptables -A FORWARD -o %i -j ACCEPT; iptables -t nat -A POSTROUTING -o $interface -j MASQUERADE
    PostDown = iptables -D FORWARD -i %i -j ACCEPT; iptables -D FORWARD -o %i -j ACCEPT; iptables -t nat -D POSTROUTING -o $interface -j MASQUERADE
    SaveConfig = true
    " > wg0.conf

    echo "Server info written wg0.conf `tput setaf 2`✓ `tput sgr0`"
    echo ""

    for n in $(seq 1 $n_clients );
    do
        cn=$((n+1))
        echo "
        [Peer]
        PublicKey = `cat client${n}_public_key`
        AllowedIPs = 10.200.200.${cn}/32
        " >> wg0.conf

        echo "Clent${n} info written wg0.conf `tput setaf 2`✓ `tput sgr0`"
        echo ""
        
        

        echo "
        [Interface]
        Address = 10.200.200.${cn}/32
        PrivateKey = `cat client${n}_private_key`
        DNS = 1.1.1.1

        [Peer]
        PublicKey = `cat server_public_key`
        Endpoint = ${ip}:51820
        AllowedIPs = 0.0.0.0/0
        PersistentKeepalive = 21
        " > client${n}.conf


        echo "Clent${n}.conf genarated `tput setaf 2`✓ `tput sgr0`"
        echo ""

    done

     
    sudo cp wg0.conf  /etc/wireguard/
    
    echo "Copied wg0.conf to /etc/wireguard/ `tput setaf 2`✓ `tput sgr0`"
    echo ""
    

    sudo chown -v root:root /etc/wireguard/wg0.conf 1> /dev/null
    sudo chmod -v 600 /etc/wireguard/wg0.conf 1> /dev/null

    echo "wg0.conf file permission chnaged to root `tput setaf 2`✓ `tput sgr0`"
    echo ""

    wg-quick up wg0

    echo "Started wg0 `tput setaf 2`✓ `tput sgr0`"
    echo ""


    

    sudo sed -i -e "/net.ipv4.ip_forward=1/s/^#//" /etc/sysctl.conf
    sudo sysctl -p 1> /dev/null
    echo "Enabled IP forwarding `tput setaf 2`✓ `tput sgr0`"
    echo ""

    rm wg0.conf
    echo "Clean up job done `tput setaf 2`✓ `tput sgr0`"
    echo ""
    echo "==================================================================================="

    echo "==================================================================================="
    echo ""
    echo "                         wiregurad setup completed!                                            "
    echo ""
    echo "==================================================================================="



else
    echo "`tput setaf 1`Unable to install wireguard Setup Failed"
    echo ""
    echo "==================================================================================="

fi

