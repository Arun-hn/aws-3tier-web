# Part 6: External Load Balancing & Auto Scaling
# Step 6a: Create Web Tier AMI
resource "aws_ami_from_instance" "threeta_web_ami" {
  name               = "WebTierImage"
  source_instance_id = aws_instance.webtier.id
  depends_on         = [aws_lb.threeta_extlb]
  description        = "Image of our Web Tier Instance"
}

# Step 6b: Create LB Target Groups
resource "aws_lb_target_group" "threeta_web_tier_target_group" {
  name     = "WebTierTargetGroup"
  protocol = "HTTP"
  port     = 80
  vpc_id   = aws_vpc.threetierarch_vpc.id
  health_check {
    path = "/health"

  }
}

# Step 6c: Create Internet Facing Load Balancer
resource "aws_lb" "threeta_extlb" {
  name               = "web-tier-external-lb"
  internal           = false
  load_balancer_type = "application"
  subnets            = [aws_subnet.public_subnet_az_1.id, aws_subnet.public_subnet_az_2.id]
  security_groups    = [aws_security_group.internetlb-sg.id]
  depends_on         = [aws_instance.webtier]
}

resource "aws_lb_listener" "threeta_extlb_listener" {
  load_balancer_arn = aws_lb.threeta_extlb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.threeta_web_tier_target_group.arn
  }
}

# Step 6d: Launch Template
resource "aws_launch_template" "threeta-web-launch" {
  name                   = "3TA-Web-Launch-Template"
  image_id               = aws_ami_from_instance.threeta_web_ami.id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.webtier-sg.id]

}

# Step 6e: Auto Scaling
resource "aws_autoscaling_group" "threeta_web_asg" {
  name                = "WebTierASG"
  desired_capacity    = 2
  min_size            = 2
  max_size            = 2
  vpc_zone_identifier = [aws_subnet.public_subnet_az_1.id, aws_subnet.public_subnet_az_2.id]
  target_group_arns   = [aws_lb_target_group.threeta_web_tier_target_group.arn]
  launch_template {
    id      = aws_launch_template.threeta-web-launch.id
    version = "$Latest"

  }
}