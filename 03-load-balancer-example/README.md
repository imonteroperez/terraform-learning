# Load balancer example

Creates a load balancer in front of the autoscaling group created in the last exercise using AWS ELB service. For that purpose it performs the following:

- Setups an 'aws_elb' resource for all the availability zones
- Setups inside the elb resource a lister to forward the HTTP request (tcp/80) to the server port defined (tcp/8080)
- Setups a new security group to allow the ingress traffic via tcp/80 
- Reconfigure the autoscaling group to setup that it will use a load balancer defined inside the aws_elb resource

Optionally, setup a health check every 30 seconds to '/' URL and provide the DNS solved URL of the ELB as output in order to perform a `curl`

```
...
Outputs:

elb_dns_name = terraform-elb-example-1226758151.us-east-2.elb.amazonaws.com
imontero@imontero:~/desarrollo/proyectos/terraform-learning/terraform-learning/03-load-balancer-example$ curl terraform-elb-example-1226758151.us-east-2.elb.amazonaws.com
Hello, World
```
