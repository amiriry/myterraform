#!/bin/bash
# install ifconfig an stuff
apt intsall net-tools

# install docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg|apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt update
apt install -y docker-ce
apt-mark hold docker-ce

# install kubernetes components
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
echo deb https://apt.kubernetes.io/ kubernetes-xenial main > /etc/apt/sources.list.d/kubernetes.list
apt-get update
apt install -y kubelet kubeadm kubectl
apt-mark hold kubelet kubeadm kubectl

# add sysctl parameter for bridge networking
echo "net.bridge.bridge-nf-call-iptables=1" >> /etc/sysctl.conf
sysctl -p

kubeadm init --pod-network-cidr=10.244.0.0/16
mkdir -p /home/ubuntu/.kube
cp -i /etc/kubernetes/admin.conf /home/ubuntu/.kube/config
chown ubuntu:ubuntu /home/ubuntu/.kube
chown ubuntu:ubuntu /home/ubuntu/.kube/config

# initiating calico for networking
wget https://docs.projectcalico.org/v3.14/manifests/calico.yaml
kubectl apply -f calico.yaml
mv calico.yaml /home/ubuntu/


