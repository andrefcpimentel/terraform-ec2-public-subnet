variable "environment_name" {
  description = "Environment Name"
  default = "Test_provisionTF"
}

variable "aws_region" {
  description = "AWS region"
  default = "eu-west-1"
}

variable "ami_id" {
  description = "ID of the AMI to provision. Default is AWS AMI Base Image"
  default = "ami-0fad7378adf284ce0"
}

variable "private_key_path" {
  type = "string"
  default = "andre-ec2.pem"
}

variable "instance_type" {
  description = "type of EC2 instance to provision."
  default = "t2.small"
}

variable "hashistack_vault_version"  { default = "1.0.2" }
variable "hashistack_vault_url"      { default = "" }


variable "local_ip_url" { default = "http://169.254.169.254/latest/meta-data/local-ipv4" }

# Optional variables
variable "vpc_cidr" {
  default = "10.19.0.0/16"
}

variable "subnet_cidrs" {
  default = "10.19.0.0/20"

}

variable "cidr_blocks" {
  default = ["0.0.0.0/32"]
}

variable "key_name" {
  default = "your-key-name"
  
}

variable "vpcAvailabilityZone1" {
   default = "eu-west-1a"
}