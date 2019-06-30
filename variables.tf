variable "aws_region" {
  description = "Region for the VPC"
  default = "ap-south-1"
}

variable "vpc_cidr" {
  description = "CIDR for the VPC"
  default = "10.1.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR for the public subnet"
  default = "10.1.1.0/24"
}

variable "private_subnet_cidr" {
  description = "CIDR for the private subnet"
  default = "10.1.2.0/24"
}

variable "ami" {
  description = "Amazon Linux AMI"
  default = "ami-0d2b3ddf9d639567a"

}

variable "key_path" {
  description = "SSH Public Key path"
  default = "public_key"
}
