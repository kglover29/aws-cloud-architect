variable "region" {
  description = "Used to set the provider being used"
}
variable "ami" {
  default = ""
}
variable "instance_type" {
  default = ""
}
variable "admin_password" {
  description = "Windows Administrator password to login as."
}
variable "profile" {}
variable "vpc_id" {}
variable "account_id" {}
variable "team_name" {}
variable "tags_map" {type = "map"}
variable "egress_rules" {type = "list"}
variable "ingress_rules" {type = "list"}
