provider "aws" {
  region = "us-west-2"
}

resource "aws_instance" "blue" {
  ami           = "ami-0abcdef1234567890" # Replace with a valid AMI
  instance_type = "t2.micro"
  tags = {
    Name        = "Blue-Environment"
    Environment = "Blue"
  }
}

resource "aws_instance" "green" {
  ami           = "ami-0abcdef1234567890" # Replace with a valid AMI
  instance_type = "t2.micro"
  tags = {
    Name        = "Green-Environment"
    Environment = "Green"
  }
}

resource "aws_elb" "web" {
  name               = "blue-green-elb"
  availability_zones = ["us-west-2a", "us-west-2b"]

  listener {
    instance_port     = 80
    instance_protocol = "HTTP"
    lb_port           = 80
    lb_protocol       = "HTTP"
  }

  instances = [aws_instance.blue.id]
  tags = {
    Environment = "Production"
  }
}

resource "null_resource" "switch_traffic" {
  provisioner "local-exec" {
    command = <<EOT
      echo "Switching traffic to Green environment"
      aws elb register-instances-with-load-balancer --load-balancer-name blue-green-elb --instances ${aws_instance.green.id}
      aws elb deregister-instances-from-load-balancer --load-balancer-name blue-green-elb --instances ${aws_instance.blue.id}
    EOT
  }
  depends_on = [aws_instance.green]
}

