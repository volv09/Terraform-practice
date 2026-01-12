variable "ami_id" {
  type        = string
  description = "AMI ID"
}

variable "instance_type" {
  type        = string
  description = "Type of EC2 instance"
  default     = "t3.micro"
}

variable "subnet_id" {
  type        = string
  description = "Subnet ID where EC2 instance will be created"
}

variable "sg_ids" {
  type        = list(string)
  description = "Security group(s) that will to be assinged to EC2 instance"
}

variable "volume_size" {
  type        = number
  description = "Size of ebs that will be assigned to EC2 instance"
  default     = 8
}

variable "volume_type" {
  type        = string
  description = "Type of ebs that will be assigned to EC2 instance"
  default     = "gp3"
}

variable "instance_name" {
  type        = string
  description = "Name of EC2 instance"
}
