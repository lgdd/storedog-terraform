resource "aws_instance" "storedog_ec2" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  key_name                    = var.ec2_key_name
  vpc_security_group_ids      = [aws_security_group.storedog_sg.id]
  subnet_id                   = aws_subnet.storedog_vpc_public_subnet.id
  associate_public_ip_address = true

  user_data = templatefile("${path.module}/user_data.sh", {
    dd_api_key                   = var.dd_api_key
    dd_app_key                   = var.dd_app_key
    dd_site                      = var.dd_site
    dd_hostname                  = "${var.ec2_instance_name}-${random_string.storedog_id.result}"
    dd_storedog_rum_app_id       = var.dd_storedog_rum_app_id
    dd_storedog_rum_client_token = var.dd_storedog_rum_client_token
  })

  root_block_device {
    volume_size = var.storage_in_gb
  }

  tags = {
    Name = "${var.ec2_instance_name}-${random_string.storedog_id.result}"
  }
}
