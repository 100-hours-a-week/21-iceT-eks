resource "aws_iam_role" "ec2_s3_access" {
  name = "ec2-to-s3-access-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "ec2.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy" "s3_access_policy" {
  name = "S3ReadAccess"
  role = aws_iam_role.ec2_s3_access.name

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["s3:ListBucket"]
        Resource = "arn:aws:s3:::koco-db-backup"
      },
      {
        Effect   = "Allow"
        Action   = ["s3:GetObject"]
        Resource = "arn:aws:s3:::koco-db-backup/*"
      }
    ]
  })
}


resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2-to-s3-access-profile"
  role = aws_iam_role.ec2_s3_access.name
}

resource "aws_instance" "mysql_server" {
  ami                    = "ami-05a7f3469a7653972"
  instance_type          = "t3.medium"
  subnet_id              = var.subnet_private_id
  private_ip             = var.ip                           # 고정 프라이빗 IP 지정
  vpc_security_group_ids = [var.security_group_db_sg_id]
  key_name               = var.key_pair_name
  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name

  user_data = base64encode(<<-EOF
    #!/bin/bash
    set -e
    export DEBIAN_FRONTEND=noninteractive

    echo "=== Installing MySQL from MySQL APT Repository ==="
    wget https://dev.mysql.com/get/mysql-apt-config_0.8.29-1_all.deb
    DEBIAN_FRONTEND=noninteractive dpkg -i mysql-apt-config_0.8.29-1_all.deb

    echo "=== Installing MySQL ==="
    apt-get update
    apt-get install -y mysql-server

    echo "=== Configuring MySQL ==="
    # 모든 IP에서 접속 허용
    sed -i 's/^bind-address\s*=.*$/bind-address = 0.0.0.0/' /etc/mysql/mysql.conf.d/mysqld.cnf
    sed -i 's/^mysqlx-bind-address\s*=.*$/mysqlx-bind-address = 0.0.0.0/' /etc/mysql/mysql.conf.d/mysqld.cnf

    echo "=== Starting MySQL ==="
    systemctl enable mysql
    systemctl restart mysql

    echo "=== Creating MySQL Users ==="
    mysql --user=root <<EOSQL
    ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'koco';
    CREATE USER IF NOT EXISTS 'was_user'@'%' IDENTIFIED BY 'koco';
    GRANT ALL PRIVILEGES ON koco.* TO 'was_user'@'%';
    FLUSH PRIVILEGES;
    EOSQL

    echo "=== Installing AWS CLI ==="
    apt-get install -y unzip curl
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip -q awscliv2.zip
    ./aws/install

    echo "=== Restoring Backup from S3 ==="
    TMP_DIR="/tmp/koco-db"
    mkdir -p "$TMP_DIR"
    chown ubuntu:ubuntu "$TMP_DIR" || true
    cd "$TMP_DIR"

    # 최신 백업 파일 추출
    LATEST_BACKUP=$(aws s3 ls s3://koco-db-backup/ --recursive \
      | awk '{print $4}' \
      | grep -E '^koco_[0-9]{8}\.sql$' \
      | sort -V \
      | tail -n1)

    if [ -z "$LATEST_BACKUP" ]; then
      echo "❌ No backup file found. Skipping restore."
      exit 1
    fi

    echo "✅ Latest backup file: $LATEST_BACKUP"
    aws s3 cp "s3://koco-db-backup/$LATEST_BACKUP" .

    echo "=== Restoring to MySQL ==="
    mysql -u root -pkoco -e "CREATE DATABASE IF NOT EXISTS koco;"
    mysql -u root -pkoco koco < "$LATEST_BACKUP"

    echo "✅ All done."
    EOF
  )

  tags = merge(tomap({
        Name =  "db-${var.stage}-${var.servicename}"}), var.tags)
}