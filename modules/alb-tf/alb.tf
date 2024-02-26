# --------- Create an ALB and its dependencies  -------
variable "myvpc_id" {
  type = string
}

variable "private_subnet_1_id" {
  type = string
}
variable "private_subnet_2_id" {
  type = string
}
variable "public_subnet_1_id" {
  type = string
}
variable "public_subnet_2_id" {
  type = string
}

# Define security group for ALB
resource "aws_security_group" "alb_sg" {
  vpc_id = var.myvpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

   egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  } 

  tags = {
    Name = "alb-sg"
  }
}

# Define ALB
resource "aws_lb" "my_alb" {
  name               = "my-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [var.public_subnet_1_id,var.public_subnet_2_id]
}



# ----------- Lauch Configuration, Auto Scaling Group, Target Group, and Listener -----------
# Define launch configuration
# Define security group for ALB
resource "aws_security_group" "ec2_sg" {
  vpc_id = var.myvpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
   // cidr_blocks = [aws_security_group.alb_sg.id]
    security_groups = [ aws_security_group.alb_sg.id ]
  }

  tags = {
    Name = "ec2-sg"
  }
}

resource "aws_launch_configuration" "my_lc" {
  name                 = "my-lc"
  image_id             = "ami-07761f3ae34c4478d"
  instance_type        = "t2.micro"
  security_groups      = [aws_security_group.ec2_sg.id]
  root_block_device {
        volume_size = 8
        volume_type = "gp2"
    }
  
  /*
  ebs_block_device {
        device_name           = "/dev/sdb"
        volume_size           = 1
        volume_type           = "gp2"
        delete_on_termination = true
    }*/
  lifecycle {
        create_before_destroy = true 
  }
  user_data            = <<-EOF
    #!/bin/bash
    echo "<h1>Hello World from $(hostname -f)</h1>" > index.html
    nohup python -m SimpleHTTPServer 80 &
    EOF
}

# Define auto scaling group
resource "aws_autoscaling_group" "my_asg" {
  name                 = "my-asg"
  min_size             = 2
  max_size             = 3
  desired_capacity     = 2
  launch_configuration = aws_launch_configuration.my_lc.name
  vpc_zone_identifier  = [var.private_subnet_1_id,var.private_subnet_2_id]
  target_group_arns    = [aws_lb_target_group.my_tg.arn]
}

# Define target group
resource "aws_lb_target_group" "my_tg" {
  name     = "my-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.myvpc_id
}

# Define listener
resource "aws_lb_listener" "my_listener" {
  load_balancer_arn = aws_lb.my_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.my_tg.arn
  }
}