resource "aws_db_subnet_group" "groups" {
  name = "db-groups"
  subnet_ids = var.private_subnets

  tags = {
    Name = "db_subnet-group"
  }
}

resource "aws_security_group" "data" {
  name = "data-sg"
  description = "Allow mysql inbound traffic"
  vpc_id = var.vpc_id

  ingress {
    description = "Traffic"
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
  }

  tags = {
    Name = "data_server-sg"
  }
}

data "aws_secretsmanager_secret_version" "credentials" {
  secret_id = "${var.secret_id}"
}

locals {
  cred = jsondecode(
    data.aws_secretsmanager_secret_version.credentials.secret_string
  )
}

resource "aws_db_instance" "db" {
  identifier = "${var.identifier}-${var.environment}"
  allocated_storage = "${var.allocated_storage}"
  storage_type = "${var.storage_type}"
  engine = "${var.engine}"
  engine_version = "${var.engine_version}"
  instance_class = "${var.instance_class}"
  name = "${var.database_name}"
  publicly_accessible = false
  db_subnet_group_name = aws_db_subnet_group.groups.name
  vpc_security_group_ids = [aws_security_group.data.id]
  username = local.cred.username
  password = local.cred.password

  depends_on = [aws_db_subnet_group.groups, aws_security_group.data]
}
