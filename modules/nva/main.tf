data "google_compute_subnetwork" "router" {
  name    = provider::google::name_from_id(var.subnet_id)
  project = provider::google::project_from_id(var.subnet_id)
  region  = provider::google::region_from_id(var.subnet_id)
}

locals {
  region = provider::google::region_from_zone(var.zone)
}

# NB: This is not intedned for production use. The random genration of
# the octet is to be used as an example only
locals {
  advertised_route = cidrsubnet("203.0.113.0/24", 8, random_integer.octet.result)
}

resource "random_integer" "octet" {
  min = 0
  max = 255
  keepers = {
    netname = var.name
  }
}

resource "google_compute_address" "interface" {
  project      = var.project_id
  name         = "${var.name}-${local.region}-address-interface"
  region       = local.region
  subnetwork   = var.subnet_id
  address_type = "INTERNAL"
}

resource "google_compute_address" "interface_redundant" {
  project      = var.project_id
  name         = "${var.name}-${local.region}-address-interface-redundant"
  region       = local.region
  subnetwork   = var.subnet_id
  address_type = "INTERNAL"
}

resource "google_compute_address" "address_peer" {
  project      = var.project_id
  name         = "${var.name}-${local.region}-address-peer"
  region       = local.region
  subnetwork   = var.subnet_id
  address_type = "INTERNAL"
}

resource "google_compute_instance" "nva" {
  project        = var.project_id
  name           = "${var.name}-${local.region}-nva"
  zone           = var.zone
  machine_type   = "e2-medium"
  can_ip_forward = true

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-lts"
    }
  }

  network_interface {
    network_ip = google_compute_address.address_peer.address
    subnetwork = var.subnet_id
    access_config {
      // Ephemeral public IP
    }
  }

  metadata_startup_script = <<-EOT
    #!/bin/bash
    apt-get update
    apt-get install -y quagga quagga-doc

    cat <<EOF > /etc/quagga/daemons
    bgpd=yes
    EOF

    cat <<EOF > /etc/quagga/bgpd.conf
    hostname bgpd
    password zebra
    log file /var/log/quagga/bgpd.log
    router bgp ${var.peer_asn}
      bgp router-id ${google_compute_address.address_peer.address}
      network ${local.advertised_route}
      neighbor ${google_compute_address.interface.address} remote-as ${var.router_asn}
    EOF

    cat <<EOF > /etc/quagga/zebra.conf
    hostname zebra
    password zebra
    log file /var/log/quagga/zebra.log
    EOF

    chown quagga:quagga /etc/quagga/*.conf
    chmod 640 /etc/quagga/*.conf

    systemctl enable zebra
    systemctl start zebra
    systemctl enable bgpd
    systemctl start bgpd

  EOT
}

resource "google_compute_router_interface" "interface" {
  project             = var.project_id
  name                = "${var.name}-${local.region}-interface"
  region              = local.region
  router              = var.router
  subnetwork          = var.subnet_id
  private_ip_address  = google_compute_address.interface.address
  redundant_interface = google_compute_router_interface.interface_redundant.name
}


resource "google_compute_router_interface" "interface_redundant" {
  project            = var.project_id
  name               = "${var.name}-${local.region}-interface-redundant"
  region             = local.region
  router             = var.router
  subnetwork         = var.subnet_id
  private_ip_address = google_compute_address.interface_redundant.address
}
