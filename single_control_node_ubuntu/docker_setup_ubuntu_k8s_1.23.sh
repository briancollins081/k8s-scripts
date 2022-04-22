# Uninstall old versions
sudo apt-get remove docker docker-engine docker.io containerd runc

# Install using the repository
sudo apt-get update
sudo apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release
    
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io

# set the cgroup to systemd requred by kubeadm by default as of Apri 2022 on ubuntu systems
echo '{ "exec-opts": ["native.cgroupdriver=systemd"] }' > /etc/docker/daemon.json

sudo apt-get autoremove
