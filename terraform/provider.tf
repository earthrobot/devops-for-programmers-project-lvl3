terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "1.22.2"
    }
  }
}

provider "digitalocean" {
  token = var.do_token
}

variable "do_token" {}
variable "pvt_key" {
  default = "~/.ssh/id_rsa_do"
}
