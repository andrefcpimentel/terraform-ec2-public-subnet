terraform {
  required_version = ">= 0.11.0"
}

provider "aws" {
  region = "${var.aws_region}"
}



resource "aws_vpc" "main" {
  cidr_block           = "${var.vpc_cidr}"
  enable_dns_hostnames = true

  tags {
    Name = "${var.environment_name}"
  }
}

resource "aws_default_network_acl" "default-acl" {
  default_network_acl_id = "${aws_vpc.main.default_network_acl_id}"

  ingress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  egress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }
  tags {
    Name = "${var.environment_name}-vpc-SG"
  }
}



resource "aws_subnet" "public" {

  vpc_id                  = "${aws_vpc.main.id}"
  availability_zone       = "${var.vpcAvailabilityZone1}"
  cidr_block              = "${var.subnet_cidrs}"
  map_public_ip_on_launch = true

  tags {
    Name = "${var.environment_name}-subnet-public"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = "${aws_vpc.main.id}"

  tags {
    Name = "${var.environment_name}-GW"
  }
}

resource "aws_route_table" "public_route" {
  vpc_id = "${aws_vpc.main.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.main.id}"
  }

  tags = {
     Name = "${var.environment_name}-public-route"
  }
}


resource "aws_route_table_association" "route_assoc_public" {
  subnet_id      = "${aws_subnet.public.id}"
  route_table_id = "${aws_route_table.public_route.id}"
}

resource "aws_security_group" "public" {
  name        = "${var.environment_name}-public"
  description = "${var.environment_name}-public"
  vpc_id      = "${aws_vpc.main.id}"
}


resource "aws_security_group_rule" "ssh" {
  security_group_id = "${aws_security_group.public.id}"
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 22
  to_port           = 22
  cidr_blocks       = "${var.cidr_blocks}"
}

resource "aws_security_group_rule" "egress" {
  security_group_id = "${aws_security_group.public.id}"
  type              = "egress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
}




resource "aws_instance" "vault" {
  ami           = "${var.ami_id}"
  instance_type = "${var.instance_type}"
  availability_zone = "${var.aws_region}a"
  subnet_id = "${aws_subnet.public.id}"
  key_name = "${var.key_name}"
  security_groups = ["${aws_security_group.public.id}",]
  tags {
    Name = "${var.environment_name}"
  }
 
}





