#!/bin/bash

# 1. Docker Installation
sudo apt-get update
sudo apt-get install -y ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
$(. /etc/os-release && echo \"$VERSION_CODENAME\") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# 2. OpenVPN Docker Image Installation and Run
docker pull openvpn/openvpn-as

# Prompt user for port numbers
echo "Default ports are:"
echo " - Web interface: 943"
echo " - SSL: 443"
echo " - UDP: 1194"

read -p 'Would you like to change the default ports? (y/n): ' change_ports
if [[ "$change_ports" =~ ^[Yy]$ ]]; then
    read -p 'Enter port for web interface (default 943): ' PORT_943
    PORT_943=${PORT_943:-943}
    read -p 'Enter port for SSL (default 443): ' PORT_443
    PORT_443=${PORT_443:-443}
    read -p 'Enter port for UDP (default 1194): ' PORT_1194
    PORT_1194=${PORT_1194:-1194}
else
    PORT_943=943
    PORT_443=443
    PORT_1194=1194
fi

# Run the OpenVPN container with the specified ports
sudo docker run -d \
  --name=openvpn-as --cap-add=NET_ADMIN \
  -p $PORT_943:943 -p $PORT_443:443 -p $PORT_1194:1194/udp \
  -v /path/to/data:/openvpn \
  openvpn/openvpn-as

# 3. Display Information
echo -e "\e[32mOpenVPN Access Server is running.\e[0m"
echo -e "\e[32mUsername: openvpn\e[0m"
echo -e "\e[32mPassword: [Set using sacli command]\e"
echo -e "\e
