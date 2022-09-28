provider "aws" {
  region = "ap-south-1"
}

########### VPC #############

resource "aws_vpc" "myVpc" {
  cidr_block = "10.0.0.0/16"
}

############### Internet Gateway ###############

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.myVpc.id

  tags = {
    Name = "igw"
  }
}

############# Subnet #############

resource "aws_subnet" "mysubnet" {
  vpc_id     = aws_vpc.myVpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "subnet"
  }
}

############## Route Table ##############

resource "aws_route_table" "route" {
  vpc_id = aws_vpc.myVpc.id

  route = []

  tags = {
    Name = "route_table"
  }
}

############ Security Group #################

resource "aws_security_group" "sg" {
  name        = "allow_all_traffic"
  description = "Allow all inbound traffic"
  vpc_id      = aws_vpc.myVpc.id

  ingress {
    description      = "All traffic"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = null
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "all-traffic"
  }
}

########### Route Table Association ##############

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.mysubnet.id
  route_table_id = aws_route_table.route.id
}

############ Ec2 Instance #############

resource "aws_instance" "ec2" {
  ami           = "ami-01216e7612243e0ef"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.mysubnet.id
  tags = {
    Name = "HelloWorld"
  }
}
