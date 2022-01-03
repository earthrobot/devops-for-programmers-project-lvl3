resource "digitalocean_vpc" "vpc" {
  name     = "my-vpc"
  region   = "ams3"
}

resource "digitalocean_droplet" "webservers" {
  count              = 2
  image              = "docker-20-04"
  name               = "web-${count.index + 1}"
  region             = "ams3"
  size               = "s-1vcpu-1gb"
  vpc_uuid = digitalocean_vpc.vpc.id
  private_networking = true

  ssh_keys = [
    data.digitalocean_ssh_key.mykey.id
  ]
}

resource "digitalocean_loadbalancer" "lb" {
  name   = "loadbalancer"
  region = "ams3"
  vpc_uuid = digitalocean_vpc.vpc.id

  sticky_sessions {
    type               = "cookies"
    cookie_name        = "lb"
    cookie_ttl_seconds = 120
  }

  dynamic "forwarding_rule" {
    for_each = [
      {
        port     = 80
        protocol = "http"
      }
    ]

    content {
      entry_port = forwarding_rule.value["port"]

      entry_protocol = forwarding_rule.value["protocol"]

      target_port     = 8080
      target_protocol = "http"
    }
  }

  healthcheck {
    port     = 8080
    protocol = "http"
    path     = "/"
  }

  droplet_ids = digitalocean_droplet.webservers.*.id
}
