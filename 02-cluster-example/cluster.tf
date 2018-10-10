#
# Example to setup a cluster of web servers
#

provider "aws" {
  region = "us-east-2"
}

resource "aws_autoscaling_group" "example" {
  launch_configuration = "${aws_launch_configuration.example.id}"
  availability_zones = ["${data.aws_availability_zones.all.names}"]

  min_size = 2
  max_size = 10

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

# Reuse an existing security group using a data provider filter
data "aws_security_groups" "sg" {
  filter {
    name = "group-name"
    values = ["imontero-terraform-example"]
  }

#  filter {
#    name = "vpc-id"
#    values = ["vpc-cbd3eaa3"]
#  }
}

data "aws_availability_zones" "all" {}

variable "server_port" {
  description = "The port the server will use for HTTP requests"
  default = 8080
}

# Take into account the use of 'ids' instead of 'id' (internal terraform-like id)
#
# NOTE: Take a look inside terraform.tfstate file for attributes: 
# 
# "data.aws_security_groups.sg": {
#    "type": "aws_security_groups",
#    "depends_on": [],
#    "primary": {
#        "id": "terraform-20181010074410389600000001",
#        "attributes": {
#           "filter.#": "1",
#           "filter.4220522619.name": "group-name",
#           "filter.4220522619.values.#": "1",
#           "filter.4220522619.values.0": "imontero-terraform-example",
#           "id": "terraform-20181010074410389600000001",
#           "ids.#": "1",
#           "ids.0": "sg-01610d883b31f9507",
#           "vpc_ids.#": "1",
#           "vpc_ids.0": "vpc-cbd3eaa3"
#        },
#        "meta": {},
#        "tainted": false
#   },
#   "deposed": [],
#   "provider": "provider.aws"
#  }
output "sgs" {
  value = ["${data.aws_security_groups.sg.ids}"]
}
