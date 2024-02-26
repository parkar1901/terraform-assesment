# terraform-assesment
terraform-assesment

# How it works?
In this terraform script, I have create 2 modules
   1. VPC module
   2. Application Load Balancer module

# 1. VPC module
This module creates following AWS services
A. VPC
B. 2 Public Subnet
C. 2 Private Subnet
D. Internet Gateway and attached It to VPC
E. Route Table for Public Subnet with route to Internet Gateway
F. Route Table for Private Subnet

# 2. Application Load Balancer module
This module creates following AWS services
A. ALB Security group
B. EC2 Security group with ingress rule to ALB security group
C. Application Load Balancer in public subnet
D. Auto Scalling Launcg configuration with Target group of Ec2 servers in private subnet
E. Attach the ALB Listener rule with Target group
