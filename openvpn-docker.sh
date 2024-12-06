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
docker run -d \
  --name=openvpn-as --cap-add=NET_ADMIN \
  -p 943:943 -p 443:443 -p 1194:1194/udp \
  -v /path/to/data:/openvpn \
  openvpn/openvpn-as

# Prompt for port numbers
read -p 'Enter port for web interface (default 943): ' PORT_943
PORT_943=${PORT_943:-943}
read -p 'Enter port for SSL (default 443): ' PORT_443
PORT_443=${PORT_443:-443}
read -p 'Enter port for UDP (default 1194): ' PORT_1194
PORT_1194=${PORT_1194:-1194}

# 3. Display Information
echo -e "\e[32mOpenVPN Access Server is running.\e[0m"
echo -e "\e[32mUsername: openvpn\e[0m"
echo -e "\e[32mPassword: [Set using sacli command]\e
