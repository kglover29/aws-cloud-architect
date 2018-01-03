# Specify the provider and access details
provider "aws" {
  region = "${var.aws_region}"
}

# Lookup the correct AMI based on the region specified
data "aws_ami" "amazon_windows_2016" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["Windows_Server-2016-English-Core-Base-*"]
  }
}


data "template_file" "init" {
    /*template = "${file("user_data")}"*/
    template = <
  winrm quickconfig -q & winrm set winrm/config/winrs @{MaxMemoryPerShellMB="300"} & winrm set winrm/config @{MaxTimeoutms="1800000"} & winrm set winrm/config/service @{AllowUnencrypted="true"} & winrm set winrm/config/service/auth @{Basic="true"}


  netsh advfirewall firewall add rule name="WinRM in" protocol=TCP dir=in profile=any localport=5985 remoteip=any localip=any action=allow
  $admin = [ADSI]("WinNT://./administrator, user")
  $admin.SetPassword("${var.admin_password}")
  /* iwr -useb https://omnitruck.chef.io/install.ps1 | iex; install -project chefdk -channel stable -version 0.16.28 */

EOF

    vars {
      admin_password = "${var.admin_password}"
    }
}

resource "aws_instance" "win2016_instance" {
  connection {
    type = "winrm"
    user = "Administrator"
    password = "${var.admin_password}"
  }
  instance_type = "${var.aws_instance_type}"
  ami = "${lookup(var.aws_amis, var.aws_region)}"
  key_name = "${var.key_name}"
  tags = "${var.tags_map}"
  key_name = "${lookup(var.key_name, var.aws_region)}"
  iam_instance_profile = "STATIC_ROLE_NAME_SHOULD_BE_A_VARIABLE"
  subnet_id = "${lookup(var.aws_subnet_id, var.aws_region)}"
  vpc_security_group_ids = ["${lookup(var.aws_security_group, var.aws_region)}"]
  /*user_data = "${file("user_data")}"*/
  user_data = "${data.template_file.init.rendered}"
}
