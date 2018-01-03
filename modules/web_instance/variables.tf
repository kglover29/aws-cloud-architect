variable "instance_type" {
  default = "t2.micro"
}

variable "admin_password" {
  description = "Windows Administrator password to login as."
}

variable "region" {}

variable "profile" {}

variable "instance_profile" {}

variable "vpc_id" {}

# variable "subnet_id" {}

variable "tags_map" {
  description = "Resource tags to set on all resources in module"
  type = "map"
}

# variable "key_name" {
#   description = ""
#   default = ""
# }
