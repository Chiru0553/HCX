output "network_config" {
  description = "Network configuration for HCX migration"
  value = {
    vpc_name    = google_project_network.this.name
    subnet_name = google_compute_subnetwork.this.name
  }
}

# Optional: Define additional output variables based on your requirements