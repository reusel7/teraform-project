# Createing VPC //////////////////////////////////////////////////////

resource "aws_vpc" "artash_vpc" {
  cidr_block = "10.10.10.0/24"
  tags = {
    Name = "artash-vpc"
  }

}
# Createing VPC first subnets ///////////////////////////////////////

resource "aws_subnet" "artash_subnet_1" {
  vpc_id            = aws_vpc.artash_vpc.id
  cidr_block        = "10.10.10.0/27"
  availability_zone = "us-east-2a"
}

resource "aws_subnet" "artash_subnet_2" {
  vpc_id            = aws_vpc.artash_vpc.id
  cidr_block        = "10.10.10.32/27"
  availability_zone = "us-east-2b"
}

resource "aws_subnet" "artash_subnet_3" {
  vpc_id            = aws_vpc.artash_vpc.id
  cidr_block        = "10.10.10.64/27"
  availability_zone = "us-east-2c"
}

resource "aws_subnet" "artash_subnet_4" {
  vpc_id            = aws_vpc.artash_vpc.id
  cidr_block        = "10.10.10.96/27"
  availability_zone = "us-east-2z"
}

# Create security_group allowed allowed all incoming traffic to VPC ports ///////////////////////////

resource "aws_security_group" "artash_SG" {
  name        = "artash_SG"
  description = "Allow inbound traffic"
  vpc_id      = aws_vpc.artash_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
