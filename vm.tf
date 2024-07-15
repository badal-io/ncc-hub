resource "google_compute_instance" "workload" {
  project      = var.project_id
  for_each     = { for vpc in module.vpc : vpc.network_name => vpc.subnets_self_links[0] }
  name         = each.key
  machine_type = "n1-standard-2"
  zone         = "${var.default_region}-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    subnetwork = each.value
  }

  metadata_startup_script = <<-EOF
    #!/bin/bash
    # Update package list and install Nginx
    sudo apt-get update
    sudo apt-get install -y nginx

    # Create a simple HTML page
    echo "<html><body><h1>Welcome to Nginx on GCP!</h1></body></html>" | sudo tee /var/www/html/index.html

    # Ensure Nginx is started
    sudo systemctl start nginx
    sudo systemctl enable nginx
  EOF

  depends_on = [module.routers]
}
