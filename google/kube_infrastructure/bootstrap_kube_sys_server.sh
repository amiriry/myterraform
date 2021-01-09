#!/bin/bash
# install ifconfig an stuff
apt install -y net-tools

# install docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg|apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt update
apt install -y docker-ce
apt-mark hold docker-ce

# install kubernetes components
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
echo deb https://apt.kubernetes.io/ kubernetes-xenial main > /etc/apt/sources.list.d/kubernetes.list
apt update
apt install -y kubelet kubeadm kubectl
apt-mark hold kubelet kubeadm kubectl

# add sysctl parameter for bridge networking
echo "net.bridge.bridge-nf-call-iptables=1" >> /etc/sysctl.conf
sysctl -p

sudo kubeadm init --pod-network-cidr=10.244.0.0/16
mkdir -p /home/amirshkedy/.kube
cp -i /etc/kubernetes/admin.conf /home/amirshkedy/.kube/config
chown -R amirshkedy:amirshkedy /home/amirshkedy/.kube

# initiating calico for networking
wget https://docs.projectcalico.org/v3.14/manifests/calico.yaml
kubectl apply -f calico.yaml
mv calico.yaml /home/amirshkedy/

cat <<'EOF' > /home/amirshkedy/get_connection_string.sh
#!/bin/bash
myip=$(kubectl get nodes -lnode-role.kubernetes.io/master -o yaml | grep "\- address" | head -1 | grep -E "[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}" | sed 's/.*: //' | tr -d '\n')
key_token=$(kubeadm token list | tail -1 | awk '{print $1}')
server_token=$(openssl x509 -pubkey -in /etc/kubernetes/pki/ca.crt | openssl rsa -pubin -outform der 2>/dev/null | openssl dgst -sha256 -hex | sed 's/^.* //')
echo "kubeadm join $myip:6443 --token $key_token --discovery-token-ca-cert-hash sha256:$server_token"
EOF

chown amirshkedy:amirshkedy /home/amirshkedy/get_connection_string.sh
chmod u+x /home/amirshkedy/get_connection_string.sh


