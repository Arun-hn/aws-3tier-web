# Part 3: App Tier Instance Deployment
resource "aws_instance" "apptier" {
  ami           = var.ami
  instance_type = var.instance_type
  subnet_id     = aws_subnet.private_subnet_az_1.id

  vpc_security_group_ids = [aws_security_group.private-instance-sg.id]
  depends_on             = [aws_rds_cluster_instance.dbclusterinstance]
  user_data = templatefile("app_user_data.sh", {
    WRITER-ENDPOINT = aws_rds_cluster.dbcluster.endpoint
    USERNAME        = var.db_username
    PASSWORD        = var.db_password
  })
  tags = {
    Name = "AppLayer"
  }
}
