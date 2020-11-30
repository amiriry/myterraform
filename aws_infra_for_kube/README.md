## Information
The files here and specifically aws_infra_for_kube.tf create an infrastructure of kubernetes with master and as much workers as you choose. 
The process of getting it running is explained under

## Installing the environment
Choose the amount of worker instances you want by chaging the `count` in the file *aws_infra_for_kube.tf*.<br />
You need yo have the same number of names as `count` under `variable "instance_names"`. <br />
Indexes of names starts with zero. 

Create Your own ssh key  with <br />
`ssh-keygen` <br />
Following the instructions. <br />
Copy the name of the public key, example `mykey.pub` and put it in the file *aws_infra_for_kube.tf* under `aws_key_pair` resource, inside `file` function in `public_key` attribute. <br />
The public key shown there adhere to this example

Create public key: <br />
`ssh-keygen` <br />
Follow the instructions after doing the command. <br />
You will use the private key that is created, with ssh to connect to the instances: <br />
`ssh -i <private_key_file> ubuntu@<instance_ip>`

Run `terraform apply` and do the following: <br />
On the kubernetes master run the script *get_connection_string.sh* <br />
You can copy it manually or do: <br />
`scp -i <private_key_file> get_connection_string.sh ubuntu@<master_ip>:<path_on_instance>` <br />

This script will give you the command you need to run on each worker node to connect it to the kubernetes cluster 

The command have the structure: <br />
`kubeadm join <master_ip>:6443 --token <token> --discovery-token-ca-cert-hash sha256:<discovery_token>` <br />
`<master_ip>` - The ip of the master <br />
`<token>` - Token of one of the keys registered <br />
`<discovery_token>` - The discovery token rely on the ca certificate of the master server <br />

