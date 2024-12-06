# OpenVPN Access Server Installation Script

This repository contains a script to set up an OpenVPN Access Server using Docker on Ubuntu. The script includes Docker installation and configuration for OpenVPN Access Server.

## Prerequisites

- An Ubuntu server
- Internet connection
- Administrative privileges

## Installation

Follow these steps to set up the OpenVPN Access Server:

1. **Download and Run the Script**

   Use the following one-liner command to download the installation script from this repository, make it executable, and run it:

   ```bash
   curl -o open-vpn.sh https://raw.githubusercontent.com/Augustine423/openvpn-docker/main/openvpn-docker.sh && chmod +x open-vpn.sh && ./open-vpn.sh
