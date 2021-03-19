echo "==================================================================================="
echo "                             Wireguard add clients                                   "
echo "==================================================================================="
echo""


echo "==================================================================================="
echo ""


n=$1

if [ -z "$1" ];
then

  n=1

else
    n=$1

fi

echo "Adding $n more clients "
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

echo "==================================================================================="
echo ""

if [ `sudo ls -lrt /etc/wireguard/ | grep wg0.conf | wc -l` -ne 0 ]
then
    if [ `sudo wg show | wc -l` -ne 0 ]
    then
        sudo wg-quick down wg0
        echo "Stopped wg0 `tput setaf 2`✓  `tput sgr0`"
        echo ""
    else
        echo "wg0 alredy stopped"
        echo ""
    fi

    n_exist=`sudo cat /etc/wireguard/wg0.conf  | awk -v w="[Peer]" '$1==w{n++} END{print n}' RS=' |\n'`

    for n in $(seq 1 $n );
    do
        cn=$((n+$n_exist))  
        wg genkey | tee client${cn}_private_key | wg pubkey > client${cn}_public_key
        
        echo "Genarated Keys for client${cn} `tput setaf 2`✓  `tput sgr0` "
        echo ""     

    done

    sudo cp /etc/wireguard/wg0.conf .

    echo "Copied wg0.conf to local directory `tput setaf 2`✓  `tput sgr0`"
    echo ""

    sudo chmod 777 wg0.conf

    echo "Changed permissions of wg0.conf to 777 `tput setaf 2`✓  `tput sgr0`"
    echo ""

    for n in $(seq 1 $n );
        do
        cn=$((n+$n_exist))
        cnp=$((cn+1))
        echo "
        [Peer]
        PublicKey = `cat client${cn}_public_key`
        AllowedIPs = 10.200.200.${cnp}/32
        " >> wg0.conf

        echo "Clent${cn} info written to wg0.conf `tput setaf 2`✓ `tput sgr0`"
        echo ""


        echo "
        [Interface]
        Address = 10.200.200.${cnp}/32
        PrivateKey = `cat client${cn}_private_key`
        DNS = 1.1.1.1

        [Peer]
        PublicKey = `cat server_public_key`
        Endpoint = ${ip}:51820
        AllowedIPs = 0.0.0.0/0
        PersistentKeepalive = 21
        " > client${cn}.conf

        echo "Clent${cn}.conf genarated `tput setaf 2`✓ `tput sgr0`"
        echo ""
    done

    sudo chmod 600 wg0.conf

    echo "Changed wg0.conf permissions back to 600 `tput setaf 2`✓ `tput sgr0`"
    echo ""

    sudo cp wg0.conf  /etc/wireguard/

    echo "Copied wg0.conf to /etc/wireguard/ `tput setaf 2`✓ `tput sgr0`"
    echo ""

    wg-quick up wg0
    echo "Started wg0 `tput setaf 2`✓ `tput sgr0`"
    echo ""

    sudo rm wg0.conf

    echo "Clean up job done `tput setaf 2`✓ `tput sgr0`"
    echo ""

    echo "==================================================================================="
    

    echo "==================================================================================="
    echo ""
    echo "                         Added $n Clients                                            "
    echo ""
    echo "==================================================================================="




    
else
    echo "`tput setaf 1`Wireguard config not found"
    echo ""
    echo "==================================================================================="

fi


