#!/bin/sh

echo "Installation script for Docker CE and nvidia-docker on Ubuntu 16+"

echo "Set non-interactive frontend"
echo "Script will run without any prompts"
export DEBIAN_FRONTEND=noninteractive

echo "\n###\n"
echo "Installing prerequisites for Docker CE"
echo "\n###\n"

apt-get update
apt-get remove docker docker-engine docker.io -y
apt-get autoremove -y
apt-get install -y \
    apt-utils \
    apt-transport-https \
    ca-certificates \
    curl \
    wget \
    software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -

apt-key fingerprint 0EBFCD88

sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

echo "\n###\n"
echo "Installing Docker CE"
echo "Version: Latest release"
echo "\n###\n"

apt-get update
apt-get install docker-ce

echo "\n###\n"
echo "Installing nvidia-docker"
echo "\n###\n"

curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | apt-key add -

distribution=$(. /etc/os-release;echo $ID$VERSION_ID)

curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | tee /etc/apt/sources.list.d/nvidia-docker.list

apt-get update
apt-get install nvidia-docker2

echo "Installed nvidia-docker"

echo "\n###\n"
echo "Finished with no errors."
echo "\n###\n"

usermod -aG docker jovyan

apt autoremove -y
apt clean
rm -rf /var/lib/apt/lists/*
