#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

echo "========================================"
echo " Starting Installation: Docker, kubectl, k3d"
echo "========================================"

# 1. Update package index and install prerequisites
echo "--> Installing prerequisites..."
sudo apt-get update -y
sudo apt-get install -y ca-certificates curl gnupg lsb-release

# 2. Install Docker using the official convenience script
if ! command -v docker &> /dev/null; then
    echo "--> Installing Docker..."
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
    rm get-docker.sh
    
    # Add current user to docker group to run docker without sudo
    sudo usermod -aG docker "$USER"
    echo "--> Docker installed. (Note: group changes require a logout/login to fully take effect)"
else
    echo "--> Docker is already installed."
fi

# 3. Install kubectl
if ! command -v kubectl &> /dev/null; then
    echo "--> Installing kubectl..."
    KUBECTL_VERSION=$(curl -L -s https://dl.k8s.io/release/stable.txt)
    curl -LO "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl"
    sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
    rm kubectl
    echo "--> kubectl installed."
else
    echo "--> kubectl is already installed."
fi

# 4. Install k3d
if ! command -v k3d &> /dev/null; then
    echo "--> Installing k3d..."
    curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash
    echo "--> k3d installed."
else
    echo "--> k3d is already installed."
fi

echo "========================================"
echo " Installation Complete!"
echo " Docker version: $(docker --version 2>/dev/null || echo 'Requires new shell session')"
echo " kubectl version: $(kubectl version --client --output=yaml | grep gitVersion | awk '{print $2}')"
echo " k3d version: $(k3d --version | head -n 1)"
echo "========================================"
echo "IMPORTANT: Execute 'su - \$USER' or reboot to apply Docker group permissions before running k3d."
