resource "aws_instance" "this" {
  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = var.sg_ids

  root_block_device {
    volume_size = var.volume_size
    volume_type = var.volume_type
  }

  tags = {
    Name = var.instance_name
  }
}
