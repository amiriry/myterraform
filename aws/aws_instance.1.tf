provider "aws" {
	profile = "default"
	region = var.region
}

# Create amzn2 instance with sg security group, that should already exist and keypair named keypair1111
# The instance name wil be WebServer01
resource "aws_instance" "webserver01" {
	ami = "ami-0947d2ba12ee1ff75"
	instance_type = "t2.micro"
	security_groups = ["sg"]
	user_data = <<-EOF
					#!/bin/bash
					yum update -y
					yum install -y httpd
					EOF
	key_name = "<keypair-name>"

	tags = {
		Name = "WebServer01"
	}
}
