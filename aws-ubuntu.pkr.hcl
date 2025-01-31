variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "instance_type" {
  type    = string
  default = "t2.2xlarge" // Change to "g4dn.xlarge" for GPU instances if needed, its gonna be expensive though _BEWARE_
}

variable "source_ami" {
  description = "The base AMI ID to use"
  type        = string
  default = "ami-0c7217cdde317cfec"
}
variable "subnet_id" {
  type = string
  default = "" 
}

packer {
  required_plugins {
    amazon = {
      version = ">= 1.2.8"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "blender" {
  ami_name      = "blender-aws-${formatdate("YYYY_MM_DD_HH_mm", timestamp())}"
  region        = var.aws_region
  instance_type = var.instance_type
  source_ami    = var.source_ami
  ssh_username  = "ubuntu"

  subnet_id     = var.subnet_id  
  associate_public_ip_address = true
}

build {
  sources = ["source.amazon-ebs.blender"]

  # provisioner "shell" {
  #   script = "./scripts/aws-vpc-setup.sh"
  # }
  provisioner "shell" {
    script = "./scripts/configure-service.sh"
  }

  provisioner "file" {
    source      = "./systemd/blender.service"
    destination = "/tmp/blender.service"
  }


}
