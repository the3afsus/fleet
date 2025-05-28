#!/bin/bash
set -e

echo "[*] Updating system..."
sudo apt update && sudo apt upgrade -y

echo "[*] Installing APT packages..."
sudo apt install -y \
  bloodhound \
  neo4j \
  nmap \
  ldap-utils \
  python3-pip \
  python3-venv \
  git \
  gobuster \
  smbclient \
  netcat \
  curl \
  wget \
  unzip \
  jq \
  build-essential \
  libssl-dev \
  libffi-dev \
  python3-dev \
  crackmapexec \
  seclists \
  hydra \
  libldap-2.5-0 \
  libldap-common \
  socat \
  proxychains4

echo "[*] Installing Python tools via pip..."
pip3 install --upgrade pip
pip3 install \
  ldapdomaindump \
  impacket \
  bloodhound-python

echo "[*] Installing tools from GitHub..."

# Enum4linux-NG
git clone https://github.com/cddmp/enum4linux-ng.git ~/tools/enum4linux-ng
chmod +x ~/tools/enum4linux-ng/enum4linux-ng.py

# Kerbrute
curl -Lo /usr/local/bin/kerbrute https://github.com/ropnop/kerbrute/releases/latest/download/kerbrute_linux_amd64
chmod +x /usr/local/bin/kerbrute

# Responder
git clone https://github.com/lgandx/Responder.git ~/tools/Responder

# Rubeus, SharpHound, Mimikatz (compiled binaries needed, usually run on victim)
mkdir -p ~/tools/windows
echo "[*] Download Rubeus, SharpHound, Mimikatz binaries manually or with a downloader"

echo "[*] Installation complete!"
