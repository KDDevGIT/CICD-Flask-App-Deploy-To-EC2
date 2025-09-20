output "ssh_command" {
  value = "ssh ec2-user@${aws_instance.web.public_ip}"
}
