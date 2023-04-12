# HCX Provider
terraform {
  required_providers {
    hcx = {
      source = "adeleporte/hcx"
    }
  }
}

// Provider config - On PRem instance
provider "hcx" {
    alias  = "onprem"
    hcx             = var.hcx_server
    username        = var.admin_un
    password        = var.admin_pw
}

// Site Pairing with the cloud - Remote/ target is GCVE
resource "hcx_site_pairing" "spon2gcve1" {
    url         = var.gcve_hcx_server
    username    = var.gcve_admin_un
    password    = var.gcve_admin_pw
}

// creating network profiles - management profile
resource "hcx_network_profile" "net_management" {
  site_pairing    = hcx_site_pairing.spon2gcve1
  network_name = "network1"
  name          = "Management profile (network1)"
  mtu           = 1500

  ip_range {
    start_address   = "18.132.147.242"
    end_address     = "18.132.147.242"
  }

  ip_range {
    start_address   = "18.168.66.74"
    end_address     = "18.168.66.90"
  }

  gateway           = "18.132.147.1"
  prefix_length     = 24
  primary_dns       = "18.132.147.24"
  secondary_dns     = ""
  dns_suffix        = ""

  depends_on = [hcx_site_pairing.spon2gcve1]
}

// creating network profiles - uplink profile
resource "hcx_network_profile" "net_onprem_uplink" {
    provider        = hcx.onprem
    site_pairing    = hcx_site_pairing.onPrem2vmc
    network_name  = "hcx-uplink"
    name          = "HCX-Uplink-profile"
    mtu           = 1600

    ip_range {
        start_address   = "172.17.9.104"
        end_address     = "172.17.9.106"
    }
    

    gateway           = "172.17.9.1"
    prefix_length     = 24
    primary_dns       = "172.17.9.1"
    secondary_dns     = ""
    dns_suffix        = "cpod-vcn.az-fkd.cloud-garage.net"
}

// creating network profiles - vmotion profile
resource "hcx_network_profile" "net_onprem_vmotion" {
    provider        = hcx.onprem
    site_pairing    = hcx_site_pairing.onPrem2vmc
    network_name  = "hcx-vmotion"
    name          = "HCX-vMotion-profile"
    mtu           = 1500

    ip_range {
        start_address   = "172.17.9.107"
        end_address     = "172.17.9.109"
    }
    
    gateway           = "172.17.9.1"
    prefix_length     = 24
    primary_dns       = "172.17.9.1"
    secondary_dns     = ""
    dns_suffix        = "cpod-vcn.az-fkd.cloud-garage.net"
}


data "hcx_compute_profile" "gcve_cp1" {
    name          = "gcve_cp1"
    datacenter = ""
    cluster = ""
    datastore = ""
    management_network = hcx_network_profile.net_management
    replication_network = hcx_network_profile.net_management
    uplink_network = hcx_network_profile.net_onprem_uplink
    vmotion_network = hcx_network_profile.net_onprem_vmotion
    service {
        name                = "INTERCONNECT"
    }

    service {
        name                = "VMOTION"
    }

    service {
        name                = "BULK_MIGRATION"
    }

    depends_on = [
        hcx_network_profile.net_management
    ]
}

resource "hcx_service_mesh" "service_mesh_1" {
  name                            = "sm1-on2gcve"
  site_pairing                    = hcx_site_pairing.spon2gcve1
  local_compute_profile           = hcx_compute_profile.gcve_cp1
  remote_compute_profile          = "ComputeProfile(vcenter)" # compute profile on target vcenter

  app_path_resiliency_enabled     = true
  tcp_flow_conditioning_enabled   = true

  uplink_max_bandwidth            = 10000 # This value is in Kilobites

  nb_appliances                   = 2 // Up to 16 L2 extension

  service {
    name                = "INTERCONNECT"
  }

  service {
    name                = "VMOTION"
  }

  service {
    name                = "BULK_MIGRATION"
  }

  service {
    name                = "NETWORK_EXTENSION"
  }

  service {
    name                = "DISASTER_RECOVERY"
  }

  depends_on = [
    hcx_site_pairing.spon2gcve1,
    hcx_compute_profile.gcve_cp1
  ]

}


resource "hcx_l2_extension" "l2_extension_net1" {
  site_pairing                    = hcx_site_pairing.spon2gcve1
  service_mesh_id                 = hcx_service_mesh.service_mesh_1.id
  source_network                  = "net1"
  network_type                    = "NsxtSegment"

  destination_t1                  = "cgw"
  gateway                         = "10.0.0.1"
  netmask                         = "255.255.255.0"
  egress_optimization = false
  mon = true
}


resource "hcx_l2_extension" "ls2" {
  site_pairing                    = hcx_site_pairing.C2C1toC2C2
  service_mesh_id                 = hcx_service_mesh.service_mesh_1.id
  source_network                  = "ls2"
  network_type                    = "NsxtSegment"

  destination_t1                  = "cgw"
  gateway                         = "11.0.0.1"
  netmask                         = "255.255.255.0"

  egress_optimization             = false
  mon                             = true
}


resource "hcx_l2_extension" "ls3" {
  site_pairing                    = hcx_site_pairing.C2C1toC2C2
  service_mesh_id                 = hcx_service_mesh.service_mesh_1.id
  source_network                  = "ls3"
  network_type                    = "NsxtSegment"

  destination_t1                  = "cgw"
  gateway                         = "12.0.0.1"
  netmask                         = "255.255.255.0"

  egress_optimization             = false
  mon                             = true
}


resource "hcx_l2_extension" "ls4" {
  site_pairing                    = hcx_site_pairing.C2C1toC2C2
  service_mesh_id                 = hcx_service_mesh.service_mesh_1.id
  source_network                  = "ls4"
  network_type                    = "NsxtSegment"

  destination_t1                  = "cgw"
  gateway                         = "13.0.0.1"
  netmask                         = "255.255.255.0"

  egress_optimization             = false
  mon                             = true
}


resource "hcx_l2_extension" "ls5" {
  site_pairing                    = hcx_site_pairing.C2C1toC2C2
  service_mesh_id                 = hcx_service_mesh.service_mesh_1.id
  source_network                  = "ls5"
  network_type                    = "NsxtSegment"

  destination_t1                  = "cgw"
  gateway                         = "14.0.0.1"
  netmask                         = "255.255.255.0"

  egress_optimization             = false
  mon                             = true
}


resource "hcx_l2_extension" "ls6" {
  site_pairing                    = hcx_site_pairing.C2C1toC2C2
  service_mesh_id                 = hcx_service_mesh.service_mesh_1.id
  source_network                  = "ls6"
  network_type                    = "NsxtSegment"

  destination_t1                  = "cgw"
  gateway                         = "15.0.0.1"
  netmask                         = "255.255.255.0"

  egress_optimization             = false
  mon                             = true
}


resource "hcx_l2_extension" "ls7" {
  site_pairing                    = hcx_site_pairing.C2C1toC2C2
  service_mesh_id                 = hcx_service_mesh.service_mesh_1.id
  source_network                  = "ls7"
  network_type                    = "NsxtSegment"

  destination_t1                  = "cgw"
  gateway                         = "16.0.0.1"
  netmask                         = "255.255.255.0"

  egress_optimization             = false
  mon                             = true
}


resource "hcx_l2_extension" "ls8" {
  site_pairing                    = hcx_site_pairing.C2C1toC2C2
  service_mesh_id                 = hcx_service_mesh.service_mesh_1.id
  source_network                  = "ls8"
  network_type                    = "NsxtSegment"

  destination_t1                  = "cgw"
  gateway                         = "17.0.0.1"
  netmask                         = "255.255.255.0"

  egress_optimization             = false
  mon                             = true

  appliance_id                    = hcx_service_mesh.service_mesh_1.appliances_id[1].id
}

output "compute_profile_vmc" {
    value = data.hcx_compute_profile.vmc_cp
}

output "service_mesh_vmc" {
    value = hcx_service_mesh.service_mesh_1
}

/*

resource "hcx_site_pairing" "onPrem2vmc" {
    provider    = hcx.onprem
    url         = "https://hcx.sddc-18-135-22-243.vmwarevmc.com"
    username    = "cloudadmin@vmc.local"
    password    = "changeme"

}

resource "hcx_network_profile" "net_onprem_management" {
    provider        = hcx.onprem
    site_pairing    = hcx_site_pairing.onPrem2vmc
    network_name  = "hcx-management"
    name          = "HCX-Management-profile"
    mtu           = 1500

    ip_range {
        start_address   = "172.17.9.101"
        end_address     = "172.17.9.103"
    }

    gateway           = "172.17.9.1"
    prefix_length     = 24
    primary_dns       = "172.17.9.1"
    secondary_dns     = ""
    dns_suffix        = "cpod-vcn.az-fkd.cloud-garage.net"
}




resource "hcx_compute_profile" "compute_profile_1" {
    provider              = hcx.onprem
    name                  = "comp1"
    datacenter            = "cPod-VCN"
    cluster               = "Cluster"
    datastore             = "vsanDatastore"

    management_network    = hcx_network_profile.net_onprem_management.id
    replication_network   = hcx_network_profile.net_onprem_management.id
    uplink_network        = hcx_network_profile.net_onprem_uplink.id
    vmotion_network       = hcx_network_profile.net_onprem_vmotion.id
    dvs                   = "dvs7"

    service {
        name                = "INTERCONNECT"
    }

    service {
        name                = "WANOPT"
    }

    service {
        name                = "VMOTION"
    }

    service {
        name                = "BULK_MIGRATION"
    }

    service {
        name                = "NETWORK_EXTENSION"
    }

    service {
        name                = "DISASTER_RECOVERY"
    }

}

resource "hcx_service_mesh" "onprem_sm1" {
    provider                        = hcx.onprem
    name                            = "sm1"
    site_pairing                    = hcx_site_pairing.onPrem2vmc
    local_compute_profile           = hcx_compute_profile.compute_profile_1.name
    remote_compute_profile          = "ComputeProfile(vcenter)"

    app_path_resiliency_enabled     = false
    tcp_flow_conditioning_enabled   = false

    uplink_max_bandwidth            = 10000

    service {
        name                = "INTERCONNECT"
    }

    service {
        name                = "VMOTION"
    }

    service {
        name                = "BULK_MIGRATION"
    }

    service {
        name                = "NETWORK_EXTENSION"
    }

    service {
        name                = "DISASTER_RECOVERY"
    }

}


resource "hcx_l2_extension" "l2_vlan1902" {
    provider                        = hcx.onprem
    site_pairing                    = hcx_site_pairing.onPrem2vmc
    service_mesh_id                 = hcx_service_mesh.onprem_sm1.id
    source_network                  = "vlan1902"

    destination_t1                  = "cgw"
    gateway                         = "10.19.2.1"
    netmask                         = "255.255.255.0"
}
*/
