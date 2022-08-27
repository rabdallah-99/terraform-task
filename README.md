# terraform-task
This repository contains a code for my approach to deploy using terraform a webserver which is accessed via application load balancer
The webserver is deployed on two instances each on different availability zone within the same region on AWS.
The webserver is nginx docker image.

This repository contains the following :

 1) screenshots folder:  contains screenshots to the running webserver , instances , virtual private cloud (vpc) , application load balancer, network interfaces, security group and resource summary
 2) script folder: contains a basic bash script that runs as a post installation script install docker and runs nginx container
 3) variables.tf -> contains some variables like image name and region to use
 4) alb.tf  -> application load balancer configuration it contains the target and health check values, creates listener, application load balancer and associate the target group to the load balancer
 5) main.tf  -> This file contains the provider declaration for the AWS provider , declaration of vpc, the instance configuration and security group
 6) outputs.tf  -> This file contains the dns name for the load balancer 
 
 
 
