resource "google_project_network" "this" {
  name       = var.vpc_name
  project_id = var.project_id

  auto_create_subnetworks = false # Disable auto-creation of subnetworks
}

resource "google_compute_subnetwork" "this" {
  name          = var.subnet_name
  project_id    = var.project_id
  region        = var.region
  network       = google_project_network.this.self_link
  ip_cidr_range = var.subnet_cidr

  # Optional: Configure additional subnetwork settings
  private_ip_google_access = var.private_ip_google_access
}

resource "google_compute_firewall" "this" {
  name       = "allow-ssh"
  project_id = var.project_id

  network = google_project_network.this.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = var.ssh_source_ranges
}

# Optional: Create additional firewall rules based on the input variable var.firewall_rules