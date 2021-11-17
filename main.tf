provider "aws" {
  region = "ap-south-1"
}

variable "vpcname" {
  type    = string
}
resource "aws_vpc" "test" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = var.vpcname
  }
}

output "vpcid" {
   value = aws_vpc.test.id
}
