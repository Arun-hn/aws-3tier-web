# Part 5: Web Tier Instance Deployment
# Step 5a: Deploy web instance
resource "aws_instance" "webtier" {
  ami                         = var.ami
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public_subnet_az_1.id
  vpc_security_group_ids      = [aws_security_group.webtier-sg.id]
  associate_public_ip_address = true
  user_data = templatefile("web_user_data.sh", {
    INT-LOAD-BALANCER-DNS = aws_lb.threeta_intlb.dns_name
  })
  tags = {
    Name = "WebLayer"
  }
}