#application load balancer configuration
#Target group
resource "aws_lb_target_group" "target-group" {
	health_check {
		interval		= 10
		path			= "/"
		protocol		= "HTTP"
		timeout			= 5
		healthy_threshold	= 5
		unhealthy_threshold	= 2
	}

	name		= "test-tg"
	port		= 80
	protocol	= "HTTP"
	target_type	= "instance"
	vpc_id		= "${module.vpc.vpc_id}"
}

#Create ALB
resource "aws_lb" "application-lb" {
	name			= "test-alb"
	internal		= false
	ip_address_type		= "ipv4"
	load_balancer_type	= "application"
	security_groups		= [aws_security_group.open_ports.id]
	subnets			= module.vpc.public_subnets

	tags = {
	   Name = "test-alb"
	}
}

#Create Listener
resource "aws_lb_listener" "alb-listener" {
	load_balancer_arn		= aws_lb.application-lb.arn
	port				= 80
	protocol			= "HTTP"
	default_action {
		target_group_arn	= aws_lb_target_group.target-group.arn
		type			= "forward"
	}
}

#Attaching load balancer with the instance to the target group
resource "aws_lb_target_group_attachment" "ec2_attach" {
	count			= length(aws_instance.webserver)
	target_group_arn	= aws_lb_target_group.target-group.arn
	target_id		= aws_instance.webserver[count.index].id
}
