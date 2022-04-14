cat <<EOF | sudo tee /etc/modules-load.d/containerd.conf
overlay
br_netfilter
EOF

sudo modprobe overlay
sudo modprobe br_netfilter

# Setup required sysctl params, these persist across reboots.
cat <<EOF | sudo tee /etc/sysctl.d/99-kubernetes-cri.conf
net.bridge.bridge-nf-call-iptables  = 1
net.ipv4.ip_forward                 = 1
net.bridge.bridge-nf-call-ip6tables = 1
EOF

# Apply sysctl params without reboot
sudo sysctl --system

wget https://github.com/containerd/containerd/releases/download/v1.6.1/cri-containerd-cni-1.6.1-linux-amd64.tar.gz
sudo tar --no-overwrite-dir -C / -xzf cri-containerd-cni-1.6.1-linux-amd64.tar.gz
sudo systemctl daemon-reload
sudo systemctl enable --now containerd

sudo mkdir /etc/containerd
sudo containerd config default > /etc/containerd/config.toml
