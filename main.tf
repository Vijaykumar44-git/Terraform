provider "aws" {
   region = "ap-south-1"
}

resource "aws_vpc" "vpc1" {
   cidr_block = "10.0.0.0/16"
   tags = {
      name = "VPC"
}
   
