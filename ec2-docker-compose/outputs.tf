output "instance" {
  value = "${var.ec2_instance_name}-${random_string.storedog_id.result}"
}

output "ssh" {
  value = "ssh -i ~/.ssh/${var.ec2_key_name} ubuntu@${aws_instance.storedog_ec2.public_ip}"
}

output "storedog" {
  value = "http://${aws_instance.storedog_ec2.public_dns}"
}

