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

variable "jenkins_base_snapshot" {
  type        = string
  description = "The base image ID with all required dependencies to run Jenkins"
}

variable "ssh_keys" {
  type = list(string)
}

provider "hcloud" {
  token = var.hcloud_token
}

resource "hcloud_server" "jenkins_master" {
  name        = "jenkins-master"
  server_type = "cx11"
  location    = "nbg1"
  image       = var.jenkins_base_snapshot
  ssh_keys    = var.ssh_keys
}

output "jenkins_master_addr" {
  value = hcloud_server.jenkins_master.ipv4_address
}
