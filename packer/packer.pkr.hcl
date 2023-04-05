packer {
  required_plugins {
    amazon = {
      version = ">= 0.0.2"
      source  = "github.com/hashicorp/amazon"
    }
    ansible = {
      version = "1.0.1"
      source  = "github.com/hashicorp/ansible"
    }
  }
}
locals {
  timestamp = regex_replace(timestamp(), "[- TZ:]", "")
}
source "amazon-ebs" "ubuntu" {
  ami_name      = "packer-${local.timestamp}"
  instance_type = "t2.micro"
  region        = "us-west-1"
  source_ami = "ami-081a3b9eded47f0f3"
  ssh_interface = "public_ip"
  ssh_username = "ubuntu"
  tags  = {
    Name  = "thunth15-packer"
  }
}

build {
  name = "thunth15-packer"
  sources = [
    "source.amazon-ebs.ubuntu"
  ]

provisioner "shell" {
  execute_command = "echo 'ubuntu'  | sudo -S env {{ .Vars}} {{ .Path}}"
  inline  = [
    "apt-add-repository ppa:ansible/ansible -y",
    "/usr/bin/apt-get update",
    "/usr/bin/apt-get -y install ansible",
    "mkdir /tmp/static_web",
    "sudo chmod 777 /tmp/static_web"
  ]
}
provisioner "file"  {
  source  = "static_web/"
  destination = "/tmp/static_web"
}
provisioner "ansible-local" {
  playbook_file = "playbook.yml"
}
provisioner "shell" {
  inline  = ["sudo /bin/cp -rf /tmp/static_web/  /var/www/html/"]
}
}