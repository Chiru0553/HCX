variable "project_id" {
  description = "ID of the Google Cloud project"
}

variable "vpc_name" {
  description = "Name of the VPC to be created on GCVE"
}

variable "subnet_name" {
  description = "Name of the subnet to be created on GCVE"
}

variable "subnet_cidr" {
  description = "CIDR block for the subnet"
}

variable "private_ip_google_access" {
  description = "Enable or disable private IP Google Access for the subnet"
  type        = bool
  default     = false
}

variable "ssh_source_ranges" {
  description = "List of source IP ranges for SSH ingress rule"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

# Optional: Define additional input variables based on your requirements