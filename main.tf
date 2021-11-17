provider "aws" {
   region = "ap-south-1"
}

resource "aws_instance" "ec2" {
   ami = "ami-0f1fb91a596abf28d"
   instance_type = "t2.micro"
   security_groups = [aws_security_group.sg.name]
   key_name = aws_key_pair.key.id

  provisioner "local-exec" {
     command = "touch /root/terraform/ec2key/1.txt"
  }
}

variable "ingressrule" {
   type = list(number)
   default = [80,8080,443]
}
variable "egressrule" {
   type = list(number)
   default = [80,8080]
}


resource "aws_security_group" "sg" {
   name = "Allow HTTP rules1"
   description = "Security group rules"

   dynamic "ingress" {
      iterator = port
      for_each = var.ingressrule
      content {
      from_port = port.value
      to_port = port.value
      protocol = "TCP"
      cidr_blocks = ["0.0.0.0/0"]
      }
   }
   dynamic "egress" {
      iterator = port
      for_each = var.egressrule
      content {
      from_port = port.value
      to_port = port.value
      protocol = "TCP"
      cidr_blocks = ["0.0.0.0/0"]
      }
   }
   tags = {
     Name = "TestSecurityGroup"
   }
}

output "sgid" {
  value = aws_security_group.sg.id
}


resource "aws_key_pair" "key" {
   key_name = "sample"
   public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCgxW0mPKS6i+s9KDtnRrthbN1SUNVk710VOcwEhMQMRPcS5ySedFyg7RXTtyrNNOxevhBYFQs2kpXQ+EBz3vigrglvljgtaVh/X8v6n/55RmEo80M94nGIRmAklb7OO843hkoEcDgwuOiPOaVpjTraW6pWku+7hfklNDK26IDdfCLWMbIGDqVXsEldlPXoeZ1K0qDJWjt0laCquiULMwAanP+8HqmjtkVsH0fBVNnN6+OvVjqVGaVr/ZlXCYEVmdDbz943nd4jZuW3aVic0f8NFzagiP5evM93IL5xmj8VFHlHPRf4OJjrsm9zfldMvZSN7cgt15k/MriAsdTp9ZiJ root@master"
}
