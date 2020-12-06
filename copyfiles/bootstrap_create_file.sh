#!/bin/bash

cat <<'EOF' > /home/ubuntu/get_connection_string.sh
#!/bin/bash
myip=\$(kubectl get nodes -lnode-role.kubernetes.io/master -o yaml | grep "\- address" | grep -v ip | sed 's/.*: //')
key_token=\$(kubeadm token list | tail -1 | awk '{print \$1}')
server_token=\$(openssl x509 -pubkey -in /etc/kubernetes/pki/ca.crt | openssl rsa -pubin -outform der 2>/dev/null | openssl dgst -sha256 -hex | sed 's/^.* //')
echo "kubeadm join \$myip:6443 --token \$key_token --discovery-token-ca-cert-hash sha256:\$server_token"
EOF

chown ubuntu:ubuntu /home/ubuntu/get_connection_string.sh
chmod u+x /home/ubuntu/get_connection_string.sh


