resource "aws_security_group" "storedog_sg" {
  vpc_id      = aws_vpc.storedog_vpc.id

  tags = {
    Name = "${var.ec2_instance_name}-${random_string.storedog_id.result}--sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "storedog_ssh_ipv4" {
  security_group_id = aws_security_group.storedog_sg.id
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
  cidr_ipv4         = var.my_public_ip_cidr
}

resource "aws_vpc_security_group_ingress_rule" "storedog_http_ipv4" {
  security_group_id = aws_security_group.storedog_sg.id
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
  cidr_ipv4         = var.my_public_ip_cidr
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.storedog_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv6" {
  security_group_id = aws_security_group.storedog_sg.id
  cidr_ipv6         = "::/0"
  ip_protocol       = "-1"
}
