variable "aws_region" {
	description	= "AWS Region London "
	default		= "eu-west-2"
}

variable "aws_amis" {
	default = "ami-0fb391cce7a602d1f"
}

variable "public_key_path" {
	description	= "The path to the SSH public key to add to AWS. "
	default		= "~/.ssh/pk-AWS.pem"
}

variable "key_name" {
	description	= "AWS key name"
	default		= "keypair name"
}

variable "instance_count" {
	default = 1
}
