#!/bin/bash
set -e

echo "Creating user 'blender-user' if it does not exist..."
if ! id -u blender-user >/dev/null 2>&1; then
  sudo useradd -m -s /bin/bash blender-user
fi

echo "Installing system updates and required packages..."
sudo apt-get update -y
sudo apt-get upgrade -y

# Install Blender via snap, the desktop environment, NICE DCV, and Xorg.
sudo snap install blender --classic
sudo apt-get install -y ubuntu-desktop nice-dcv-server xorg

echo "Moving systemd service file to /etc/systemd/system/..."
sudo mv /tmp/blender.service /etc/systemd/system/blender.service

echo "Reloading systemd daemon and enabling the Blender service..."
sudo systemctl daemon-reload
sudo systemctl enable blender.service
sudo systemctl start blender.service

echo "Configuration complete."
