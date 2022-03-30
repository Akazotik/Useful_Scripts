echo -e "                                                       
╦  ╦╔═╗╔╗╔  ╦╔╗╔╔═╗╔╦╗╔═╗╦  ╦  
╚╗╔╝╠═╝║║║  ║║║║╚═╗ ║ ╠═╣║  ║  
 ╚╝ ╩  ╝╚╝  ╩╝╚╝╚═╝ ╩ ╩ ╩╩═╝╩═╝
"

echo -e "Добро пожаловать! Данный скрипт поможет вам установить следующие компоненты на ваш сервер:
1. Wireguard VPN
2. DNS server bind 9
3. Добавить клиентов на ваш сервер WireGuard
4. Сгенерировать конфигурационный файл для клиента wireguard
Также скрипт поможет вам добавить клиентов wireguard, а также сгенерировать конфигурационные файлы для них"

for (( ; ; ))
do 
echo -e "\\nДля начала работы выберите необходимый пункт:
1. Установка Wireguard VPN
2. Установка dns сервера 
3. Добавление клиента в wireguard
4. Генерация конфигурационного файла для пользователя wireguard
5. Выход


Выберите пункт: "

read punkt

patt="[1-6]"

for (( ; ; ))
do
if [[ $punkt != $patt ]]
then
echo "Выберите пункт:"
read punkt
else
break
fi
done
case $punkt in 
1) echo "Начата установка Wiregurad"
apt install sudo -y 
sudo apt install wireguard -y
sudo apt install iptables -y
sudo sh "echo 'net.ipv4.ip_forward = 1
net.ipv6.conf.all.disable_ipv6 = 1
net.ipv6.conf.default.disable_ipv6 = 1' >> /etc/sysctl.conf"
sudo sysctl -p /etc/sysctl.conf
ser_pr=$(wg genkey | sudo tee /etc/wireguard/ser_pr.key)
ser_pb=$(echo $ser_pr | wg pubkey | sudo tee /etc/wireguard/ser_pb.key)
server_prs=$(wg genpsk | sudo tee /etc/wireguard/server_prs.key)
echo -e "[Interface] 
Address = 10.8.0.1/24 
ListenPort = 64378 
PrivateKey = '$ser_pr'
PostUp = iptables -A FORWARD -i wg0 -j ACCEPT; iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE 
PostDown = iptables -D FORWARD -i wg0 -j ACCEPT; iptables -t nat -D POSTROUTING -o eth0 -j MASQUERADE " | sudo tee /etc/wireguard/wg0.conf

sudo systemctl enable wg-lsquick@wg0
sudo systemctl start wg-quick@wg0

echo "Установка Wireguard закончена" ;;
2) echo "Установка DNS сервера BIND 9 начата"
sudo apt install bind9 -y
sudo systemctl enable named
sudo systemctl start bind9
echo -n > /etc/bind/named.conf.options
echo -e "acl goodclients {
10.8.0.0/24;
localhost;
localnets;
};
options {
        directory "/var/cache/bind";
        dnssec-validation no;
        auth-nxdomain no;    # conform to RFC1035
        recursion yes;
        listen-on { any; };
        allow-query { goodclients; };
        version "error...";
        transfers-in 25;
        transfers-out 25;
        max-cache-size 425m; # RAM = 512 MB (425) RAM = 1024 (825)
        listen-on port 53 {any;};
};" | sudo tee /etc/bind/named.conf.options
sudo sed -i 's/OPTIONS="-u bind"/OPTIONS="-4 -u bind"/g' /etc/default/named 
sudo systemctl restart bind9
sudo systemctl stop systemd-resolved && sudo systemctl disable systemd-resolved
echo -n > /etc/resolv.conf
echo "nameserver 127.0.0.1" > /etc/resolv.conf
echo "Установка DNS сервера BIND 9 закончена" ;;
3) echo "Процедура добавления клиента начата" 
echo "Введите номер клиента (минимальный номер - 2): "
read client_number

cl_pr=$(wg genkey | sudo tee /etc/wireguard/cl_pr$client_number.key)
cl_pb=$(echo $cl_pr | wg pubkey | sudo tee /etc/wireguard/cl_pb$client_number.key)
server_prs=$(sudo cat /etc/wireguard/server_prs.key)

echo "Номер клиента: $client_number"

sudo sh -c "echo  '[Peer] 
PublicKey = '$cl_pb'
PresharedKey = '$server_prs'
AllowedIPs = 10.8.0.'$client_number'/32' >> /etc/wireguard/wg0.conf"

sudo systemctl restart wg-quick@wg0 
echo "Вы добавили клиента с номером $client_number" ;;
4) echo "Процедура генерации конфигурационного файла начата"
echo "Введите IP адрес сервера: "
read IP_AD
echo "Введите номер клиента (минимальный номер - 2): "
read client_number
echo "Введите IP адрес днс сервера (при установленном bind 9 - 10.8.0.1): "
read dns_ip


cl_pr=$(sudo cat /etc/wireguard/cl_pr$client_number.key)
server_prs=$(sudo cat /etc/wireguard/server_prs.key)
ser_pb=$(sudo cat /etc/wireguard/ser_pb.key)



sudo sh -c "echo '[Interface]
Address = 10.8.0.'$client_number'/24
PrivateKey = '$cl_pr'
DNS = $dns_ip
ListenPort = 64378

[Peer]
PublicKey = '$ser_pb'
PresharedKey = '$server_prs'
AllowedIPs = 0.0.0.0/0
Endpoint = '$IP_AD':64378' > ./Userconf$client_number.conf"  
echo "Сгенерирован файл Userconf$client_number.conf, скачайте его при помощи утилиты WinSCP" ;;
5) echo "Выход"
exit ;;
esac
done

