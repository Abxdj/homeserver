#!/bin/bash

echo "=== Aizen Home Server Setup ==="

# Update system
echo "[1/7] Updating system..."
sudo apt update && sudo apt upgrade -y

# Fix lid close
echo "[2/7] Configuring lid close behavior..."
sudo sed -i 's/#HandleLidSwitch=suspend/HandleLidSwitch=ignore/' /etc/systemd/logind.conf
sudo systemctl restart systemd-logind

# Disable sleep
echo "[3/7] Disabling sleep..."
sudo systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target

# Install Docker
echo "[4/7] Installing Docker..."
curl -fsSL https://get.docker.com | sh
sudo usermod -aG docker $USER

# Install NVIDIA drivers
echo "[5/7] Installing NVIDIA drivers..."
sudo apt install -y nvidia-driver-535

# Install NVIDIA container toolkit
echo "[6/7] Installing NVIDIA container toolkit..."
curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg
curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | \
  sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
  sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list
sudo apt update && sudo apt install -y nvidia-container-toolkit
sudo nvidia-ctk runtime configure --runtime=docker

# Install Tailscale
echo "[7/7] Installing Tailscale..."
curl -fsSL https://tailscale.com/install.sh | sh

# Create storage directories
echo "Creating storage directories..."
sudo mkdir -p /mnt/storage/{downloads,media/{movies,tvshows,music},nextcloud,immich}
sudo chown -R $USER:$USER /mnt/storage

# Configure Docker DNS
echo "Configuring Docker DNS..."
sudo tee /etc/docker/daemon.json > /dev/null <<EOF
{
    "dns": ["8.8.8.8", "1.1.1.1"],
    "runtimes": {
        "nvidia": {
            "args": [],
            "path": "nvidia-container-runtime"
        }
    }
}
EOF

sudo systemctl restart docker

echo ""
echo "=== Setup Complete ==="
echo "Next steps:"
echo "1. Reboot the server: sudo reboot"
echo "2. Run: sudo tailscale up --accept-dns=false"
echo "3. Deploy your Docker services"
