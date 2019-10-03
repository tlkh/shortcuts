#!/bin/sh

echo -e "Installation script for Docker CE and nvidia-docker on Ubuntu 16+"

echo -e "Set non-interactive frontend"
echo -e "Script will run without any prompts"
export DEBIAN_FRONTEND=noninteractive

echo -e "\n###\n"
echo -e "Installing prerequisites for Docker CE"
echo -e "\n###\n"

apt-get update
apt-get remove docker docker-engine docker.io -y
apt-get install -y \
    apt-utils \
    apt-transport-https \
    ca-certificates \
    curl \
    wget \
    software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -

sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

echo -e "\n###\n"
echo -e "Installing Docker CE"
echo -e "Version: latest stable"
echo -e "\n###\n"

apt-get update
apt-get install docker-ce -y

echo -e "\n###\n"
echo -e "Installing NVIDIA drivers and CUDA"
echo -e "Driver version: latest stable"
echo -e "CUDA version: latest stable"
echo -e "Note: Will append a line to ~/.bashrc"
echo -e "\n###\n"

wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/cuda-ubuntu1804.pin
mv cuda-ubuntu1804.pin /etc/apt/preferences.d/cuda-repository-pin-600
apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/7fa2af80.pub
add-apt-repository "deb http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/ /"

apt-get update
apt-get -y install cuda

# Run Post-install Step
CUDA_PATH=$(ls /usr/local | grep -m1 cuda-)
echo "export PATH=/usr/local/$CUDA_PATH/bin:/usr/local/$CUDA_PATH/NsightCompute-2019.1\${PATH:+:\${PATH}}">> ~/.bashrc

echo -e "\n###\n"
echo -e "Installing nvidia-docker"
echo -e "Version: latest stable"
echo -e "\n###\n"

curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | apt-key add -

distribution=$(. /etc/os-release;echo -e $ID$VERSION_ID)

curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | tee /etc/apt/sources.list.d/nvidia-docker.list

apt-get update
apt-get update
apt-get install nvidia-docker2 nvidia-container-runtime -y

echo -e "\nInstalled nvidia-docker\n"

echo -e "\n###\n"
echo -e "Finished with no errors."
echo -e "\n\n[  TIP  ]\nDon't want to run Docker with sudo?"
echo -e "\nAdd your own user by running 'usermod -aG docker \$USER' normally\n"
echo -e "\n###\n"

while true; do
    read -p "We're done here! Reboot? Y/[N]" yn
    case $yn in
        [Yy]* ) reboot;;
        [Nn]* ) exit 0;;
        * ) exit 0;;
    esac
done
