#
# Example to setup a load balancer
#

provider "aws" {
  region = "us-east-2"
}

# Creates an ELB that receive HTTP requests on port 80 and to route
# them to the port used by the instances inside the autoscaling group

resource "aws_elb" "example" {
  name = "terraform-elb-example"
  availability_zones = ["${data.aws_availability_zones.all.names}"]
  security_groups = ["${aws_security_group.elb-sg.id}"]

  listener {
    lb_port = "${var.elb_port}"
    lb_protocol = "http"
    instance_port = "${var.server_port}"
    instance_protocol = "http"
  }

  # Optional: to perform a health check every 30 seconds to '/' URL
  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    interval = 30
    target = "HTTP:${var.server_port}/"
  }

}

resource "aws_security_group" "elb-sg" {
  name = "imontero-elb-example"

  ingress {
    from_port = "${var.elb_port}"
    to_port = "${var.elb_port}"
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Optional: enables to perform the health check
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}


resource "aws_autoscaling_group" "example" {
  launch_configuration = "${aws_launch_configuration.example.id}"
  availability_zones = ["${data.aws_availability_zones.all.names}"]

  min_size = 2
  max_size = 10

  load_balancers = ["${aws_elb.example.name}"]
  health_check_type = "ELB"

  tag {
    key = "Name"
    value = "terraform-asg-example"
    propagate_at_launch = true
  }
}

resource "aws_launch_configuration" "example" {
  image_id = "ami-0f65671a86f061fcd"
  instance_type = "t2.micro"

  security_groups = ["${data.aws_security_groups.sg.ids}"]

  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, World" > index.html
              nohup busybox httpd -f -p "${var.server_port}" &
              EOF

  lifecycle {
    create_before_destroy = true
  }
}

data "aws_security_groups" "sg" {
  filter {
    name = "group-name"
    values = ["imontero-terraform-example"]
  }
}

data "aws_availability_zones" "all" {}

variable "elb_port" {
  description = "The port the ELB will use for HTTP requests to be redirected to server_port"
  default = 80
}

variable "server_port" {
  description = "The port the server will use for HTTP requests"
  default = 8080
}

output "elb_dns_name" {
  value = "${aws_elb.example.dns_name}"
}
