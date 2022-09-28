provider "aws"{
   region = "ap-south-1"
}


data "aws_subnet" "selected" {
  filter {
    name   = "tag:Name"
    values = ["subnet_1"]
  } 
}

resource "aws_instance" "ec2_1" {
  ami           = "ami-062df10d14676e201"
  instance_type = "t2.micro"
  subnet_id     = data.aws_subnet.selected.id
  key_name      = "key"
  tags = {
    Name = "HelloWorld"
  }
}
