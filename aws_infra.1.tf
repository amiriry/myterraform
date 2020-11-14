provider "aws" {
	profile = "default"
	region = var.region
}

# Create vpc named myVPC
resource "aws_vpc" "myVPC" {
	cidr_block = "10.0.0.0/16"

	tags = {
		Name = "myVPC"
	}
}

# Create security group named 'mysg' that can accept ssh connection from everywhere
resource "aws_security_group" "mysg" {
	vpc_id = aws_vpc.myVPC.id
	name = "mysg"
	description = "Allow ssh and http"

	ingress {
		description = "SSH from VPC"
		from_port = 22
		to_port = 22
		protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}

	egress {
		from_port = 0
		to_port = 0
		protocol = "-1"
		cidr_blocks = ["0.0.0.0/0"]
	}
}

# Create subnet that is going to be pulic, called 'pubsub'
resource "aws_subnet" "pubsub" {
	vpc_id = aws_vpc.myVPC.id
	cidr_block = "10.0.1.0/24"
	map_public_ip_on_launch = "true"

	tags = {
		Name = "pubsub"
	}
}

# Create subnet that is going to be private, called 'privsub'
resource "aws_subnet" "privsub" {
	vpc_id = aws_vpc.myVPC.id
	cidr_block = "10.0.2.0/24"

	tags = {
		Name = "privsub"
	}
}

# Create Internet Gateway
resource "aws_internet_gateway" "myIGW" {
	vpc_id = aws_vpc.myVPC.id
	tags = {
		Name = "MyVPCGW"
	}
}

# Create NAT gateway

# Create an Elastic IP for the NAT gateway
resource "aws_eip" "natEIP" {
	vpc = true
	tags = {
		Name = "myEIP"
	}
}

# Create the NAT gateway
resource "aws_nat_gateway" "myNATGW" {
	allocation_id = aws_eip.natEIP.id
	subnet_id = aws_subnet.pubsub.id
	tags = {
		Name = "myNATGW"
	}
	depends_on = [aws_internet_gateway.myIGW]
}

# Resources related to routing

# Create Route Table
resource "aws_route_table" "pubRT" {
	vpc_id = aws_vpc.myVPC.id
	tags = {
		Name = "pubRT"
	}
}

# Create the route to the internet in my public route table
resource "aws_route" "public_internet_Access" {
	route_table_id = aws_route_table.pubRT.id
	destination_cidr_block = "0.0.0.0/0"
	gateway_id = aws_internet_gateway.myIGW.id
}

# Add route to the NAT gatewau in the default private gateway
resource "aws_route" "NAT_outside" {
	route_table_id = "<private_default_table_id>"
	destination_cidr_block = "0.0.0.0/0"
	gateway_id = aws_nat_gateway.myNATGW.id
	
}

# Associate the route table with the public subnet
resource "aws_route_table_association" "pubAssoc" {
	subnet_id = aws_subnet.pubsub.id
	route_table_id = aws_route_table.pubRT.id
}

# End of Route things

# Create public instance                          
resource "aws_instance" "pubserver" {
   ami = "ami-0947d2ba12ee1ff75"
   instance_type = "t2.micro"
   # Inside sg security group
   security_groups = [aws_security_group.mysg.id]
   subnet_id = aws_subnet.pubsub.id
   key_name = "<keypair_name>"
   tags = {
      Name = "pubserver01"
   }
}

resource "aws_instance" "privserver" {
   ami = "ami-0947d2ba12ee1ff75"
   instance_type = "t2.micro"
   # Inside sg security group
   security_groups = [aws_security_group.mysg.id]
   subnet_id = aws_subnet.privsub.id
   key_name = "<keypair_name>"
   tags = {
      Name = "privserver01"
   }
}

