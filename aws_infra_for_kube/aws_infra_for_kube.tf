provider "aws" {
	profile = "default"
	region = var.region
}

resource "aws_key_pair" "mykp" {
	key_name = "mykeypair"
	public_key = file("mykey.pub")
}

resource "aws_security_group" "mysg" {
	name = "mysg"
	description = "Allow ssh and http"

	ingress {
		description = "SSH from VPC"
		from_port = 22
		to_port = 22
		protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}

	ingress {
		description = "All trafic from self"
		from_port = 0
		to_port = 0
		protocol = "-1"
		self = true
	}

	egress {
		from_port = 0
		to_port = 0
		protocol = "-1"
		cidr_blocks = ["0.0.0.0/0"]
	}
}

resource "aws_instance" "kubeserver" {
	ami = "ami-0885b1f6bd170450c"
	# Have to be medium because kubernetes needs at least 2 CPUs
	instance_type = "t2.medium"
	security_groups = ["mysg"]
	# Script to install kubernetes server stuff
	user_data = file("bootstrap_kube_sys_server.sh") 
	key_name = "mykeypair"
	depends_on = [ aws_key_pair.mykp ]

	tags = {
		Name = "kubeserver"
	}
}

# Kubernetes workers names 
# - are going to be used as tags in the workers aws_instance resource
variable "instance_names" {
	default = {
		"0" = "worker1"
		"1" = "worker2"
		"2" = "worker3"
	}
}

resource "aws_instance" "workers" {
	ami = "ami-0885b1f6bd170450c"
	# Number of instances that are going to be created as workers
	count = 3
	# Have to be medium because kubernetes needs at least 2 CPUs
	instance_type = "t2.medium"
	security_groups = ["mysg"]
	# Script to install kubernetes worker stuff
	user_data = file("bootstrap_kube_sys_worker.sh")
	key_name = "mykeypair"
	depends_on = [ aws_instance.kubeserver, aws_key_pair.mykp ]

	tags = {
		Name = lookup(var.instance_names, count.index)
	}
}
