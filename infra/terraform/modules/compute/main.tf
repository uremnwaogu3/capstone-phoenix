data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]


  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_key_pair" "this" {
  key_name   = "${var.name}-key"
  public_key = var.public_key

}

resource "aws_instance" "server" {
  ami                    = data.aws_ami.ubuntu.id
  key_name               = aws_key_pair.this.key_name
  instance_type          = var.server_instance_type
  vpc_security_group_ids = [var.security_group_id]
  subnet_id              = var.subnet_id

  root_block_device {
    volume_size = var.disk_size_gb
    volume_type = "gp3"
    encrypted   = "true"
  }

  metadata_options {
    http_tokens = "required"

  }

  tags = {
    Name = "${var.name}-server"
    Role = "server"
  }

  lifecycle {
    ignore_changes = [ami]

  }
}

resource "aws_instance" "worker" {
  count                  = var.worker_count
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.worker_instance_type
  vpc_security_group_ids = [var.security_group_id]
  key_name               = aws_key_pair.this.key_name
  subnet_id              = var.subnet_id

  root_block_device {
    volume_size = var.disk_size_gb
    volume_type = "gp3"
    encrypted   = true
  }

  metadata_options {
    http_tokens = "required"
  }

  tags = {
    Name = "${var.name}-worker-${count.index + 1}"
    Role = "Worker"
  }

  lifecycle {
    ignore_changes = [ami]
  }
}

resource "aws_eip" "server" {
  instance = aws_instance.server.id
  domain   = "vpc"

  tags = {
    Name = "${var.name}-server"
  }
}

resource "aws_eip" "worker" {
  count    = var.worker_count
  instance = aws_instance.worker[count.index].id
  domain   = "vpc"
  tags = {
    Name = "${var.name}-worker-${count.index + 1}"

  }
}