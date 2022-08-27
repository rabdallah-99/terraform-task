terraform {
  required_providers {
      aws = {
            source = "hashicorp/aws"
	    version = "4.27.0"

      }
     }
}

provider "aws" {
  # Configuration options
	#profile = "default"
	region  = "eu-west-2"
	access_key = ""
	secret_key = ""
}

# using terraform modules to define a default vpc
# as defined in documentation
module "vpc" {
	source		= "terraform-aws-modules/vpc/aws"

	name		= "vpc-main"
	cidr		= "10.0.0.0/16"

	azs		= ["${var.aws_region}a", "${var.aws_region}b"]
	private_subnets	= ["10.0.0.0/24", "10.0.1.0/24"]
	public_subnets	= ["10.0.100.0/24", "10.0.101.0/24"]

	enable_vpn_gateway = true
	enable_nat_gateway = true


	tags		=  {
		Terraform	= "true"
		Environment	= "dev"
	    }



	}  #end of vpc

resource "aws_instance" "webserver" {
  ami				= "${var.aws_amis}"
  instance_type 		= "t2.micro"
  count				= 2
  vpc_security_group_ids	= ["${aws_security_group.open_ports.id}"]
  subnet_id			= "${element(module.vpc.public_subnets,count.index)}"
  user_data = "${file("script/init.sh")}"

  tags = {
   Name = "BasicWebServer-${count.index}"
  }

}  #end of vm configuration


#Define security groups to allow access to ssh, http and https traffic

resource "aws_security_group" "open_ports" {
	name		= "basic_webserver"
	description	= "Allow inbound HTTP SSH HTTPS traffic"
	vpc_id		= "${module.vpc.vpc_id}"

	#HTTP access
	ingress {
		from_port	= 80
		to_port		= 80
		protocol	= "tcp"
		cidr_blocks	= ["0.0.0.0/0"]
		}

	#HTTPS access
	ingress {
		from_port	= 443
		to_port		= 443
		protocol	= "tcp"
		cidr_blocks	= ["0.0.0.0/0"]
		}

	#SSH access
	ingress {
		from_port	= 22
		to_port		= 22
		protocol	= "tcp"
		cidr_blocks	= ["0.0.0.0/0"]
		}


	#egress access
	egress {
		from_port	= 0
		to_port		= 0
		protocol	= "-1"
		cidr_blocks	= ["0.0.0.0/0"]
		}
} #end of security group
