# Single webserver example

Creates a single webserver using Terraform. For that purpose it performs the following:

- Setup an AWS provider for region 'us-east-2' provided by my free-tier account
- Setup an AWS instance named 'example' for a given AWS AMI of an Ubuntu 18.04 (LTS) server
- On creation it setups as user_data a bash script that creates a simple HTTP server that serves at 'server_port' variable value defined by default to 8080
- To being able to navigate to this webserver we create a security_group providing ingress access by tcp/8080
- As output, we provide the public_ip assigned by AWS to being able to access to the service

Once obtained the public ip we can do a `curl` to check all is working fine

```
...
Outputs:

public_ip = 18.224.190.184
imontero@imontero:~/desarrollo/proyectos/terraform-learning/terraform-learning/01-single-webserver$ curl 18.224.190.184:8080
Hello, World
```

