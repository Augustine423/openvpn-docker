#!/bin/bash

# Add Docker's official GPG key and set up the repository
sudo apt-get update
sudo apt-get install -y ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Pull the OpenVPN Access Server Docker image
sudo docker pull openvpn/openvpn-as

# Prompt for port number
read -p "Enter the port number for OpenVPN (default 1194): " VPN_PORT
VPN_PORT=${VPN_PORT:-1194}

# Run the OpenVPN Access Server container
sudo docker run -d --name openvpn-as --cap-add=NET_ADMIN -p $VPN_PORT:$VPN_PORT/udp -p 443:443 -e "OPENVPN_ADMIN_PASSWORD=Useronly1!" -e "OPENVPN_AUTH_USER_PASS_ENABLED=1" -e "OPENVPN_AUTH_USER_PASS_STANDALONE=1" -e "OPENVPN_EASY_RSA=1" openvpn/openvpn-as

# Set a custom password for the OpenVPN admin user
CUSTOM_PASSWORD="Useronly1!"
sudo docker exec -it openvpn-as /bin/bash -c "sacli --user openvpn --new_pass $CUSTOM_PASSWORD SetLocalPassword && sacli start"

# Get the public and private IP addresses
PUBLIC_IP=$(curl -s http://checkip.amazonaws.com)
PRIVATE_IP=$(hostname -I | awk '{print $1}')

echo "OpenVPN Access Server is now running. Access the admin UI at: https://$PUBLIC_IP:443/admin"
echo "Download OpenVPN profiles at: https://$PUBLIC_IP:443/"
echo "Admin username: openvpn"
echo "Admin password: $CUSTOM_PASSWORD"
echo "OpenVPN UDP port: $VPN_PORT"
echo "Public IP: $PUBLIC_IP"
echo "Private IP: $PRIVATE_IP"
echo "Please ensure your security group allows incoming traffic on UDP port $VPN_PORT and TCP port 443."
