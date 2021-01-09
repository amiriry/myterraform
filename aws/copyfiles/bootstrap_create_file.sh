#!/bin/bash

cat <<'EOF' > /home/ubuntu/another_script.sh
#!/bin/bash
hostname=$(hostname)
echo "The purpose of this script is to show another way of creating a file"
echo "I am on $hostname"
echo "continuing creating this file"
EOF

chown ubuntu:ubuntu /home/ubuntu/another_script.sh
chmod u+x /home/ubuntu/another_script.sh


