#
# Example to setup a simple instance of an Ubuntu 18.04 (LTS)
#

provider "aws" {
  region = "us-east-2"
}

resource "aws_instance" "example" {
  ami = "ami-0f65671a86f061fcd"
  instance_type = "t2.micro"

  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, World" > index.html
              nohup busybox httpd -f -p "${var.server_port}" &
              EOF

  vpc_security_group_ids = ["${aws_security_group.instance.id}"]

  tags {
    Name = "imontero-terraform-example"
  }
}

resource "aws_security_group" "instance" {
  name = "imontero-terraform-example"

  ingress {
    from_port = "${var.server_port}"
    to_port = "${var.server_port}"
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

variable "server_port" {
  description = "The port the server will use for HTTP requests"
  default = 8080
}

output "public_ip" {
  value = "${aws_instance.example.public_ip}"
}

