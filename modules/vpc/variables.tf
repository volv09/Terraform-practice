variable "vpc_cidr" {
  type = string
}

variable "public_subnets" {
  type = list(object({
    cidr_block = string
    az         = string
  }))
}

variable "private_subnets" {
  type = list(object({
    cidr_block = string
    az         = string
  }))
}

variable "tags" {
  type    = map(string)
  default = {}
}

