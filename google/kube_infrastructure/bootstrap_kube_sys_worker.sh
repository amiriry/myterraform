#!/bin/bash -xe
exec > >(tee /var/log/user-data.log | logger -t user-data -s 2>/dev/console) 2>&1

# I think that this should be first
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
echo deb https://apt.kubernetes.io/ kubernetes-xenial main > /etc/apt/sources.list.d/kubernetes.list
apt update

# install ifconfig an stuff
apt install -y net-tools

# install docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg|apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt update
apt install -y docker-ce
apt-mark hold docker-ce

# install kubernetes components
apt install -y kubelet kubectl kubeadm
apt-mark hold kubelet kubeadm kubectl

# add sysctl parameter for bridge networking
echo "net.bridge.bridge-nf-call-iptables=1" >> /etc/sysctl.conf
sysctl -p
