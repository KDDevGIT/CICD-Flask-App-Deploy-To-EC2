variable "aws_region" {
  description = "AWS region for the EC2 host"
  type        = string
  default     = "us-west-1"
}

variable "project_name" {
  description = "Project tag for resources"
  type        = string
  default     = "flask-cicd-ec2"
}

variable "key_pair_name" {
  description = "Existing EC2 key pair name to allow SSH"
  type        = string
}

variable "instance_type" {
  type        = string
  default     = "t3.micro"
}

variable "allow_ssh_cidr" {
  description = "CIDR block allowed to SSH"
  type        = string
  default     = "0.0.0.0/0"
}
