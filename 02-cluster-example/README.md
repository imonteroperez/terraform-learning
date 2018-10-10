# Cluster example

Creates a cluster using an autoscaling group from AWS. For that purpose it performs the following:

- Setup an AWS provider for region 'us-east-2' provided by me free-tier account
- Setup an AWS launch configuration named 'example' that contains the AMI used in the 'Single webserver example'
- On creation it setups as user_data the same than 'Single webserver example'
- In addition, it setups the security groups needed, that will be reused from created on preliminary example
- For reusing SGs we create a data provider that filter by group-name (it could filter by vpc-id too)
- Once launch configuration is created, we create an autoscaling group for that configuration for all the availability zones provided by my account with a min size of 2 instances and a max of 10. 

Take into account the use of 'ids' instead of 'id' on data provider for security groups

```
 "data.aws_security_groups.sg": {
    "type": "aws_security_groups",
    "depends_on": [],
    "primary": {
        "id": "terraform-20181010074410389600000001",

        "attributes": {
           "filter.#": "1",
           "filter.4220522619.name": "group-name",
           "filter.4220522619.values.#": "1",
           "filter.4220522619.values.0": "imontero-terraform-example",
           "id": "terraform-20181010074410389600000001",
           "ids.#": "1",
           "ids.0": "sg-01610d883b31f9507",
           "vpc_ids.#": "1",
           "vpc_ids.0": "vpc-cbd3eaa3"
        },
        "meta": {},
        "tainted": false
   },
   "deposed": [],
   "provider": "provider.aws"
  }
```

We want to use as reference the `sg-xxx` identifier instead of `terraform-xxx` 

