#!/bin/bash

# Update package list and install prerequisites
sudo apt-get update
sudo apt-get install -y ca-certificates curl

# Add Docker's official GPG key and set up the repository
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

# Run the OpenVPN Access Server container
sudo docker run -d --name openvpn-as --cap-add=NET_ADMIN -p 1194:1194/udp -p 443:443 -e "OPENVPN_ADMIN_PASSWORD=yourpassword" -e "OPENVPN_AUTH_USER_PASS_ENABLED=1" -e "OPENVPN_AUTH_USER_PASS_STANDALONE=1" -e "OPENVPN_EASY_RSA=1" openvpn/openvpn-as

# Set a custom password for the OpenVPN admin user
CUSTOM_PASSWORD="your_custom_password"
sudo docker exec -it openvpn-as /bin/bash -c "sacli --user openvpn --new_pass $CUSTOM_PASSWORD SetLocalPassword && sacli start"

echo "OpenVPN Access Server is now running. Access the admin UI at https://your-server-ip:443/admin"
echo "Admin username: openvpn"
echo "Admin password: $CUSTOM_PASSWORD"
