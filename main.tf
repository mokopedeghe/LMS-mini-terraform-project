provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "ec2_instance" {
  count         = 3
  ami           = "ami-0fc5d935ebf8bc3bc" 
  instance_type = "t2.micro"      
  tags = {
    Name = "EC2-Instance-${count.index + 1}"
  }
}

resource "aws_elb" "altschoolLB" {
  name               = "altschoolLB-elb"
  availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c"]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    target              = "HTTP:80/"
    interval            = 30
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
  }

  instances = aws_instance.ec2_instance[*].id
}


resource "null_resource" "write_output" {
  triggers = {
    host_inventory = jsonencode(aws_instance.ec2_instance[*].public_ip)
  }

  provisioner "local-exec" {
    command = "echo '${jsonencode(self.triggers.host_inventory)}' > host_inventory.json"
  }
}

# Output public IP addresses to a file
output "host_inventory" {
  value = {
    for instance in aws_instance.ec2_instance :
    instance.tags.Name => instance.public_ip
  }
}



