# Example values for input variables

vcenter_username = "my_vcenter_username"
vcenter_password = "my_vcenter_password"
vcenter_server   = "my_vcenter_server"

vpc_name    = "my_gcve_vpc"
subnet_name = "my_gcve_subnet"

firewall_rules = [
  {
    name        = "allow-ssh"
    source_cidr = "0.0.0.0/0"
    port        = "22"
    protocol    = "tcp"
  },
  {
    name        = "allow-http"
    source_cidr = "0.0.0.0/0"
    port        = "80"
  }
]