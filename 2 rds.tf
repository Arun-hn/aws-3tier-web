# Part 2: DB Subnet Groups and DB Deployment
resource "aws_db_subnet_group" "db_subnet_group" {
  name        = "threeta-db-subnet-group"
  description = "Subnet group for the database layer of the architecture."
  subnet_ids  = [aws_subnet.private_db_subnet_az_1.id, aws_subnet.private_db_subnet_az_2.id]
}

resource "aws_rds_cluster" "dbcluster" {
  cluster_identifier     = "threeta-database-1"
  engine                 = "aurora-mysql"
  engine_version         = "5.7.mysql_aurora.2.11.2"
  master_username        = var.db_username
  master_password        = var.db_password
  skip_final_snapshot    = "true"
  apply_immediately      = "true"
  storage_encrypted      = "true"
  vpc_security_group_ids = [aws_security_group.db-sg.id]
  db_subnet_group_name   = aws_db_subnet_group.db_subnet_group.id
}

resource "aws_rds_cluster_instance" "dbclusterinstance" {
  count                      = 1
  identifier                 = "threeta-database-1-instance-${count.index}"
  cluster_identifier         = aws_rds_cluster.dbcluster.id
  instance_class             = "db.t3.small"
  engine                     = aws_rds_cluster.dbcluster.engine
  engine_version             = aws_rds_cluster.dbcluster.engine_version
  auto_minor_version_upgrade = "false"
  apply_immediately          = "true"
  promotion_tier             = "1"

}


