# Configure the AWS Provider
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.20.0"
    }
  }
}

# Create VPC
resource "aws_vpc" "test" {
  cidr_block = "10.0.0.0/16" # Specify size of the VPC network

tags = {
    Name = "my-vpc" # Specify name of the VPC
  }
}

# Create Internet-Gateway (for public subnet)
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.test.id

  tags = {
    Name = "MyVPC-IGW"
  }
}

# Create route table for public subnet
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.test.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "public-route-table"
  }
} 

# Create public subnet in AZ eu-west-1a
resource "aws_subnet" "public1" {
  vpc_id                  = aws_vpc.test.id
  cidr_block              = "10.0.1.0/24" # Specify size of the public subnet
  availability_zone       = "eu-west-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "my-vpc-subnet-public1-eu-west-1a"
  }
}

# Create rt association that associates the public route table with the public subnet
resource "aws_route_table_association" "public1" {
  subnet_id      = aws_subnet.public1.id
  route_table_id = aws_route_table.public.id
}

# Create security group that allows all inbound oublic traffic
resource "aws_security_group" "allow_all_inbound_http_traffic" {
  vpc_id      = aws_vpc.test.id

  tags = {
    Name = "allow_all_inbound_http_traffic"
  }
}

# Create security group rule to allow all inbound http traffic
resource "aws_vpc_security_group_ingress_rule" "allow_all_inbound_http_traffic" {
  security_group_id = aws_security_group.allow_all_inbound_http_traffic.id
  ip_protocol       = "tcp"
  from_port         = 80
  to_port           = 80
  cidr_ipv4         = "0.0.0.0/0"
}

# Create security group rule to allow all outbound traffic
resource "aws_vpc_security_group_egress_rule" "allow_all_outbound_traffic" {
  security_group_id = aws_security_group.allow_all_inbound_http_traffic.id
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
}

# Create EC2 instance within the public subnet in AZ eu-west-1a
resource "aws_instance" "public" {
  ami             = "ami-06297e16b71156b52"
  instance_type   = "t3.micro"
  subnet_id       = aws_subnet.public1.id
  vpc_security_group_ids = [aws_security_group.allow_all_inbound_http_traffic.id]

# Volume configuration
  root_block_device {
    volume_size = 8
    volume_type = "gp3"
  }

user_data = <<-EOF
    #!/bin/bash
    yum update -y
    yum install -y python3
    echo "<h1>Hello World from Terraform on Amazon Linux!</h1>" > /home/ec2-user/index.html
    cd /home/ec2-user
    nohup python3 -m http.server 80 &
  EOF

  tags = {
    Name = "ec2-public-instance-test"
  }
}

# Create private subnet in AZ eu-west-1a
resource "aws_subnet" "private1" {
  vpc_id            = aws_vpc.test.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "eu-west-1a"

  tags = {
    Name = "my-vpc-subnet-private1-eu-west-1a"
  }
}

# Create EC2 instance within the private subnet in AZ eu-west-1a
resource "aws_instance" "private" {
  ami           = "ami-06297e16b71156b52"
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.private1.id

  # Volume configuration
  root_block_device {
    volume_size = 8
    volume_type = "gp3"
  }

  tags = {
    Name = "ec2-private-instance-test"
  }
}

# Create public subnet in AZ eu-west-1b
resource "aws_subnet" "public2" {
  vpc_id                  = aws_vpc.test.id
  cidr_block              = "10.0.3.0/24" # Specify size of the public subnet
  availability_zone       = "eu-west-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "my-vpc-subnet-public2-eu-west-1b"
  }
}

# Create rt association that associates the public route table with the public subnet
resource "aws_route_table_association" "public2" {
  subnet_id      = aws_subnet.public2.id
  route_table_id = aws_route_table.public.id
}

# Create private subnet in AZ eu-west-1b
resource "aws_subnet" "private2" {
  vpc_id            = aws_vpc.test.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "eu-west-1b"

  tags = {
    Name = "my-vpc-subnet-private2-eu-west-1b"
  }
}
