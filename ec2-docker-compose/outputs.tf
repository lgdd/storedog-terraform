output "public_ip" {
  value = aws_instance.storedog_ec2.public_ip
}

output "public_dns" {
  value = aws_instance.storedog_ec2.public_dns
}

output "instance_id" {
  value = aws_instance.storedog_ec2.id
}

output "vpc_id" {
  value = aws_vpc.storedog_vpc.id
}

output "subnet_id" {
  value = aws_subnet.storedog_vpc_public_subnet.id
}
