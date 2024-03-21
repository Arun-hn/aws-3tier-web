# Part 4: Internal Load Balancing & Auto Scaling
# Step 4a: Create App Tier AMI
resource "aws_ami_from_instance" "threeta_app_ami" {
  name               = "AppTierImage"
  source_instance_id = aws_instance.apptier.id
  depends_on         = [aws_lb.threeta_intlb]
  description        = "App Tier"
}

# Step 4b: Create LB Target Groups
resource "aws_lb_target_group" "threeta_app_tier_target_group" {
  name     = "AppTierTargetGroup"
  protocol = "HTTP"
  port     = 4000
  vpc_id   = aws_vpc.threetierarch_vpc.id
  health_check {
    path = "/health"
  }
}

# Step 4c: Create Internal Load Balancer
resource "aws_lb" "threeta_intlb" {
  name               = "app-tier-internal-lb"
  internal           = true
  load_balancer_type = "application"
  subnets            = [aws_subnet.private_subnet_az_1.id, aws_subnet.private_subnet_az_2.id]
  security_groups    = [aws_security_group.internallb-sg.id]
  depends_on         = [aws_instance.apptier]
}

resource "aws_lb_listener" "threeta_intlb_listener" {
  load_balancer_arn = aws_lb.threeta_intlb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.threeta_app_tier_target_group.arn
  }
}

# Step 4d: Launch Template
resource "aws_launch_template" "threeta-app-launch" {
  name                   = "3TA-App-Launch-Template"
  image_id               = var.ami
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.private-instance-sg.id]

}

# Step 4e: Auto Scaling
resource "aws_autoscaling_group" "threeta_int_asg" {
  name                = "AppTierASG"
  desired_capacity    = 2
  min_size            = 2
  max_size            = 2
  vpc_zone_identifier = [aws_subnet.private_subnet_az_1.id, aws_subnet.private_subnet_az_2.id]
  target_group_arns   = [aws_lb_target_group.threeta_app_tier_target_group.arn]
  launch_template {
    id      = aws_launch_template.threeta-app-launch.id
    version = "$Latest"
  }

}
