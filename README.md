This repo contains terraform things

*aws_instance.1.tf* <br />
&nbsp;&nbsp;Create and instance with amazn2 AMI, t2.micro instance inside sg already existing Security Group. <br />
&nbsp;&nbsp;Install httpd. <br />
&nbsp;&nbsp;Use a key named `<keypair-name>` for connecting <br />

aws_infra.1.tf - 
	Create - 
		VPC named "myVPC"
		Security Group named "mysg". Open port 22 to the world and accept all.
		Public subnet called 'pubsub'
		Private subnet called 'privsub'
		Internet Gateway associated with 'myVPC'
		Elastic IP
		NAT gateway associated with the elastic ip from before. Depeneds on internet gateway
		Public route table called 'pubRT'
		Route for internet acces in pubRT
		Route in default route table from anywhere to NAT gateway
		Association between public subnet 'pubsub' and public route table 'pubRT'
		Instance in public subnet
		Instance in private subnet

	Variables:
		private_default_table_id - The id of the default private subnet created with the VPC. 
		keypair_name - The name of the key that is going to be used for connecting to the servers

	Summary:
		VPC with 2 subnets, one public and one private. The private should be able to get information from the internet through the NAT gateway, but cannot be accessed from outside.
		2 Servers one in the public subnet and the other in the private.
	Check:	
		Can be checked that it works with the command 'sudo yum update'. If it works than the infrastructure is ok.
