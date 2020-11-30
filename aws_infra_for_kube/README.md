## Information
The files here and specifically aws_infra_for_kube.tf create an infrastructure of kubernetes with master and as much workers as you choose. 
The process of getting it running is explained under

## Installing the environment
Choose the amount of worker instances you want by chaging the `count` in the file *aws_infra_for_kube.tf*
You need yo have the same number of names as `count` under `variable "instance_names"`. 
Indexes of names starts with zero. 

Create Your own ssh key and put the name of the public key inside the file function in public_key attributes under aws_key_pair resource. The public key shown here is just an example.
Create public key:
`ssh-keygen`
Follow the instructions after doing the command.
You will use the private key that is created, with ssh to connect to the instances:
`ssh -i <private_key_file> ubuntu@<instance_ip>`

Run `terraform apply` and do the following:
On the kubernetes master run the script *get_connection_string.sh*
You can copy it manually or do:
`scp -i <private_key_file> get_connection_string.sh ubuntu@<master_ip>`

This script will give you the command you need to run on each worker node to connect it to the kubernetes cluster

The command have the structure:
`kubeadm join <master_ip>:6443 --token <token> --discovery-token-ca-cert-hash sha256:<discovery_token>
`<master_ip>` - The ip of the master 
`<token>` - Token of one of the keys registered
`<discovery_token>` - The discovery token rely on the ca certificate of the master server

