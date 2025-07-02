output "aws_instance" {
  value = aws_instance.strapi_ec2.public_ip
}

output "aws_instance_with_port" {
  value = "http://${aws_instance.strapi_ec2.public_ip}:1337"
}