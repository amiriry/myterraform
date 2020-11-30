This repo contains terraform things

*aws_instance.1.tf* -  <br />
&nbsp;&nbsp;&nbsp;Create and instance with amazn2 AMI, t2.micro instance inside sg already existing Security Group. <br />
&nbsp;&nbsp;&nbsp;Install httpd. <br />
&nbsp;&nbsp;&nbsp;Use a key named `<keypair-name>` for connecting <br />

aws_infra.1.tf - <br />
&nbsp;&nbsp;&nbsp;Create - <br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;VPC named "myVPC"<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Security Group named "mysg". Open port 22 to the world and accept all.<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Public subnet called 'pubsub'<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Private subnet called 'privsub'<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Internet Gateway associated with 'myVPC'<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Elastic IP<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;NAT gateway associated with the elastic ip from before. Depeneds on internet gateway<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Public route table called 'pubRT'<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Route for internet acces in pubRT<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Route in default route table from anywhere to NAT gateway<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Association between public subnet 'pubsub' and public route table 'pubRT'<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Instance in public subnet<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Instance in private subnet<br />

#####Variables:
&nbsp;&nbsp;&nbsp;`private_default_table_id` - The id of the default private subnet created with the VPC. 
&nbsp;&nbsp;&nbsp;`keypair_name` - The name of the key that is going to be used for connecting to the servers

#####Summary:
&nbsp;&nbsp;&nbsp;VPC with 2 subnets, one public and one private. The private should be able to get information from the internet through the NAT gateway, but cannot be accessed from outside. 2 Servers one in the public subnet and the other in the private.
#####Check:	
&nbsp;&nbsp;&nbsp;Can be checked that it works with the command 'sudo yum update'. If it works than the infrastructure is ok.
