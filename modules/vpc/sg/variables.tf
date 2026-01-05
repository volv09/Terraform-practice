variable "vpc_id" {
  type = string
}

variable "sg_name" {
  type = string
}

variable "tags" {
  type = map(string)
  default = {}
}
