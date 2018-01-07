# Specify the provider and access details
provider "aws" {
  region  = "${var.region}"
  profile = "${var.profile}"
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

# Bootstrap script
data "template_file" "init" {
    /*template = "${file("user_data")}"*/
    template = <<EOF
    <script>
  winrm quickconfig -q & winrm set winrm/config/winrs @{MaxMemoryPerShellMB="300"} & winrm set winrm/config @{MaxTimeoutms="1800000"} & winrm set winrm/config/service @{AllowUnencrypted="true"} & winrm set winrm/config/service/auth @{Basic="true"}
    </script>
    <powershell>
  netsh advfirewall firewall add rule name="WinRM in" protocol=TCP dir=in profile=any localport=5985 remoteip=any localip=any action=allow
  $admin = [ADSI]("WinNT://./administrator, user")
  $admin.SetPassword("${var.admin_password}")
  netsh advfirewall firewall add rule name="HTTP in" protocol=TCP dir=in profile=any localport=80 remoteip=any localip=any action=allow

  Get-Disk | where partitionstyle -eq 'raw' | Initialize-Disk -PartitionStyle MBR -PassThru | New-Partition -DriveLetter D -UseMaximumSize | Format-Volume -FileSystem NTFS -NewFileSystemLabel "disk2" -Confirm:$false

  Install-WindowsFeature -name Web-Server

  Import-Module WebAdministration
  Set-ItemProperty 'IIS:\Sites\Default Web Site' -Name physicalPath -Value D:\inetpub\wwwroot

  Copy-S3Object -Region us-west-2 -BucketName kglover-aws-cloud-architect -KeyPrefix config -LocalFolder D:\inetpub\wwwroot
    </powershell>
  /* iwr -useb https://omnitruck.chef.io/install.ps1 | iex; install -project chefdk -channel stable -version 0.16.28 */

EOF

    vars {
      admin_password = "${var.admin_password}"
    }
}

# Default security group to access the instances via WinRM over HTTP and HTTPS
resource "aws_security_group" "web-sg" {
  name        = "allow-web"
  tags        = "${var.tags_map}"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    prefix_list_ids = ["pl-68a54001"]
  }
}

resource "aws_security_group" "rdp-sg" {
  name        = "allow-rdp"
  tags        = "${var.tags_map}"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = ["97.113.126.26/32"]
  }

  egress {
    from_port       = 3389
    to_port         = 3389
    protocol        = "tcp"
    cidr_blocks     = ["97.113.126.26/32"]
  }
}

resource "aws_eip" "bar" {
  vpc = true
  instance                  = "${aws_instance.web.id}"
}

resource "aws_instance" "web" {
  # connection {
  #   type     = "winrm"
  #   user     = "Administrator"
  #   password = "${var.admin_password}"
  # }
  instance_type          = "${var.instance_type}"
  ami                    = "${data.aws_ami.amazon_windows_2016.id}"

  # Not sure if I need to have access or keys to the box
  key_name               = "ebadmin-key-pair-us-oregon"

  tags                   = "${var.tags_map}"
  iam_instance_profile   = "${var.instance_profile}"
  vpc_security_group_ids = ["${aws_security_group.web-sg.id}", "${aws_security_group.rdp-sg.id}"]
  user_data              = "${data.template_file.init.rendered}"

  ebs_block_device {
    device_name = "xvdf"
    volume_size = "1"
  }
}
