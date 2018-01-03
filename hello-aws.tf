provider "aws" {
  region  = "${$var.region}"
  profile = "${$var.profile}"
}

terraform {
  backend "s3" {
    region  = "us-west-2"
    bucket  = "kglover-aws-cloud-architect"
    encrypt = true
    key     = "hello-aws.terraform.tfstate"
    profile = "kevin_root"
  }
}

module "web_instance" {
  region         = "us-west-2"
  instance_type  = "${var.instance_type}"
  admin_password = "${var.admin_password}"
  vpc_id         = "${}"
  tags_map       = "${var.tags_map}"
  profile        = "${var.profile}"
}

# module "s3_web_hosting" {
#
# }
