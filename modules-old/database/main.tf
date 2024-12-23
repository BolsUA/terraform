# Create a security group for RDS instances
resource "aws_security_group" "rds" {
  name        = "${var.app_name}-rds-sg-${var.environment}"
  description = "Security group for RDS instances"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidr_blocks
  }

  tags = {
    Name        = "${var.app_name}-rds-sg"
    Environment = var.environment
  }
}

# Create subnet group for RDS
resource "aws_db_subnet_group" "rds" {
  name        = "${var.app_name}-rds-subnet-group-${var.environment}"
  description = "RDS subnet group"
  subnet_ids  = var.private_subnet_ids

  tags = {
    Name        = "${var.app_name}-rds-subnet-group"
    Environment = var.environment
  }
}

# Create RDS instance for people service
resource "aws_db_instance" "people_db" {
  identifier = "${var.app_name}-people-db-${var.environment}"

  engine            = "postgres"
  engine_version    = "16.4"
  instance_class    = "db.t3.micro"
  allocated_storage = 20

  db_name  = var.people_db_name
  username = var.people_db_username
  password = var.people_db_password

  db_subnet_group_name   = aws_db_subnet_group.rds.name
  vpc_security_group_ids = [aws_security_group.rds.id]

  parameter_group_name = "default.postgres16"
  skip_final_snapshot  = true

  tags = {
    Name        = "${var.app_name}-people-db"
    Environment = var.environment
  }
}

# Create RDS instance for scholarships service
resource "aws_db_instance" "scholarships_db" {
  identifier = "${var.app_name}-scholarships-db-${var.environment}"

  engine            = "postgres"
  engine_version    = "16.4"
  instance_class    = "db.t3.micro"
  allocated_storage = 20

  db_name  = var.scholarships_db_name
  username = var.scholarships_db_username
  password = var.scholarships_db_password

  db_subnet_group_name   = aws_db_subnet_group.rds.name
  vpc_security_group_ids = [aws_security_group.rds.id]

  parameter_group_name = "default.postgres16"
  skip_final_snapshot  = true

  tags = {
    Name        = "${var.app_name}-scholarships-db"
    Environment = var.environment
  }
}

# Create RDS instance for applications service
resource "aws_db_instance" "applications_db" {
  identifier = "${var.app_name}-applications-db-${var.environment}"

  engine            = "postgres"
  engine_version    = "16.4"
  instance_class    = "db.t3.micro"
  allocated_storage = 20

  db_name  = var.applications_db_name
  username = var.applications_db_username
  password = var.applications_db_password

  db_subnet_group_name   = aws_db_subnet_group.rds.name
  vpc_security_group_ids = [aws_security_group.rds.id]

  parameter_group_name = "default.postgres16"
  skip_final_snapshot  = true

  tags = {
    Name        = "${var.app_name}-applications-db"
    Environment = var.environment
  }
}

# Create RDS instance for grading and selection service
resource "aws_db_instance" "grading_selection_db" {
  identifier = "${var.app_name}-grading-selection-db-${var.environment}"

  engine            = "postgres"
  engine_version    = "16.4"
  instance_class    = "db.t3.micro"
  allocated_storage = 20

  db_name  = var.grading_selection_db_name
  username = var.grading_selection_db_username
  password = var.grading_selection_db_password

  db_subnet_group_name   = aws_db_subnet_group.rds.name
  vpc_security_group_ids = [aws_security_group.rds.id]

  parameter_group_name = "default.postgres16"
  skip_final_snapshot  = true

  tags = {
    Name        = "${var.app_name}-grading-selection-db"
    Environment = var.environment
  }
}
