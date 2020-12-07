terraform {
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "1.23.0"
    }
  }
}

variable "hcloud_token" {
  type = string
}

variable "ssh_keys" {
  type = list(string)
}

provider "hcloud" {
  token = var.hcloud_token
}

data "hcloud_image" "jenkins_master" {
  with_selector = "name==jenkins-master,tool==packer"
  most_recent   = true
}

resource "hcloud_server" "jenkins_master" {
  name        = "jenkins-master"
  server_type = "cx11"
  location    = "nbg1"
  image       = data.hcloud_image.jenkins_master.id
  ssh_keys    = var.ssh_keys
}

output "jenkins_master_addr" {
  value = hcloud_server.jenkins_master.ipv4_address
}
