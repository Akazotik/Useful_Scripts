echo -e "
╔═╗╦ ╦╔═╗╔╦╗╔═╗╦ ╦╔═╗╔═╗╔═╗╦╔═╔═╗    ╦  ╦╦═╗╔═╗╦ ╦   ╔═╗╦  ╦ ╦╔═╗╦╔╗╔
╚═╗╠═╣╠═╣ ║║║ ║║║║╚═╗║ ║║  ╠╩╗╚═╗    ╚╗╔╝╠╦╝╠═╣╚╦╝───╠═╝║  ║ ║║ ╦║║║║
╚═╝╩ ╩╩ ╩═╩╝╚═╝╚╩╝╚═╝╚═╝╚═╝╩ ╩╚═╝     ╚╝ ╩╚═╩ ╩ ╩    ╩  ╩═╝╚═╝╚═╝╩╝╚╝
"

echo "Выберите вариант установки:
1 - чистый shadowsocks
2- shadowsocks + v2ray-plugin"
varian=""
read variant

case $variant in

1) echo "Вы выбрали вариант установки чистого shadowsocks"

sudo apt install shadowsocks-libev
echo "Введите IP адрес сервера: "
read IP_address
echo "Введите порт shadowsocks (443 или 8443): "
read port
echo "Введите пароль для подключения: "
read pass
echo "Введите DNS сервер (если установлен dnsserver(bind9, unbound) - ввести адрес сервера), в противном случае любой днс по выбору (1.1.1.1, 8.8.8.8): "
read DNS_IP
echo -e '{
    "server":["'$IP_address'"],
    "mode":"tcp_and_udp",
    "server_port":'$port',
    "local_port":1080,
    "password":"'$pass'",
    "timeout":60,
    "method":"chacha20-ietf-poly1305"
    "fast_open":true,
    "reuse_port":true,
    "nameserver":"'$DNS_IP'"
}' | sudo tee /etc/shadowsocks-libev/config.json
;;

2) echo "Вы выбрали установку shadowsocks + v2ray-plugin"
sudo apt install shadowsocks-libev
echo "Введите IP адрес сервера: "
read IP_address
echo "Введите порт shadowsocks (443 или 8443): "
read port
echo "Введите пароль для подключения: "
read pass
echo "Введите DNS сервер (если установлен dnsserver(bind9, unbound) - ввести адрес сервера), в противном случае любой днс по выбору (1.1.1.1, 8.8.8.8): "
read DNS_IP
echo "Перед следующим шагом - проверьте версию v2ray на https://github.com/shadowsocks/v2ray-plugin/releases"
sleep 10
echo "Введите версию v2ray (вида 1.3.1): "
read v2ray_version
sudo wget https://github.com/shadowsocks/v2ray-plugin/releases/download/v$v2ray_version/v2ray-plugin-linux-amd64-v$v2ray_version.tar.gz
sudo tar -xf v2ray-plugin-linux-amd64-v$v2ray_version.tar.gz
sudo mv v2ray-plugin_linux_amd64 /etc/shadowsocks-libev/v2ray-plugin
sudo setcap 'cap_net_bind_service=+eip' /etc/shadowsocks-libev/v2ray-plugin
sudo setcap 'cap_net_bind_service=+eip' /usr/bin/ss-server
echo "Выберите вариант работы плагина v2ray

1 - Shadowsocks over websocket (HTTP) (not recommended)
2 - Shadowsocks over websocket (HTTPS)
3 - Shadowsocks over quic

Введите опцию (1-3):"
var=""
read var
v2rayopts=""
case $var in
1) v2rayopts="server";;
2) echo "Введите домен для обфускации трафика (вида exapmle.com):"
read domain
v2rayopts="server;tls;host=$domain";;
3) echo "Введите домен для обфускации трафика (вида exapmle.com):"
read domain
v2rayopts="server;mode=quic;host=$domain";;
esac
echo -e '{
    "server":["'$IP_address'"],
    "mode":"tcp_and_udp",
    "server_port":'$port',
    "local_port":1080,
    "password":"'$pass'",
    "timeout":60,
    "method":"chacha20-ietf-poly1305"
    "fast_open":true,
    "reuse_port":true,
    "plugin":"/etc/shadowsocks-libev/v2ray-plugin",
    "plugin_opts":"'$v2rayopts'",
    "nameserver":"'$DNS_IP'"
}' | sudo tee /etc/shadowsocks-libev/config.json ;;

esac
systemctl restart shadowsocks-libev.service