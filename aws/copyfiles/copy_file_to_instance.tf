provider "aws" {
	profile = "default"
	region = var.region
}

resource "aws_key_pair" "mykp" {
	key_name = "mykeypair"
	public_key = file("some-public-key.pub")

}

resource "aws_security_group" "mysg" {
	name = "mysg"
	description = "Allow ssh and traffic from self"

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


resource "aws_instance" "server31" {
	ami = "ami-0885b1f6bd170450c"
	instance_type = "t2.medium"
	security_groups = ["mysg"]
	key_name = "mykeypair"
	user_data = file("bootstrap_create_file.sh") # This script creates a file, a script and gives it permissions

	connection {
		type = "ssh"
		user = "ubuntu"
		private_key = file("private_key")
		host = self.public_ip
	}

	# This copy a file from the current computer you are on
	provisioner "file" {
		source = "somescript.sh"
		destination = "/home/ubuntu/myscript.sh"
	}

	tags = {
		Name = "MyServer31"
	}
}
