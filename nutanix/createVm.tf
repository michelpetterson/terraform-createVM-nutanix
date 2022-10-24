module "phpipamModule" {
  source = "../modules/phpipam"

  for_each    = var.vms
  hostname    = each.value["name"]
  vm_network  = each.value["network"]
  bckp_subnet = var.nutanix_network_nic["bckp"]
}

data "nutanix_clusters" "clusters" {}

resource "nutanix_virtual_machine" "vm" {
  for_each                                 = var.vms
  name                                     = each.value["name"]
  use_hot_add                              = true
  cluster_uuid                             = data.nutanix_clusters.clusters.entities.0.metadata.uuid
  num_vcpus_per_socket                     = 1
  num_sockets                              = each.value["n_socket"]
  memory_size_mib                          = each.value["s_memory"]
  boot_type                                = "UEFI"
  guest_customization_cloud_init_user_data = data.cloudinit_config.userdata[each.key].rendered
  guest_customization_cloud_init_meta_data = base64encode(templatefile("templates/meta-data.tftpl", {
    "hostname" = "${each.value["name"]}"
  }))

  # Service Network
  nic_list {
    subnet_uuid = lookup(var.nutanix_network_nic, each.value["network"], var.nutanix_network_nic["default"])
  }

  # Backup network
  nic_list {
    subnet_uuid = var.nutanix_network_nic["bckp"]
  }

  disk_list {

    data_source_reference = {
      kind = "image"
      uuid = var.nutanix_vm_template
    }
  }
}

data "cloudinit_config" "userdata" {
  for_each      = var.vms
  gzip          = false
  base64_encode = true

  part {
    filename     = "cloud.cfg"
    content_type = "text/cloud-config"
    content = templatefile("templates/user-data.tftpl", {
      "hostname"    = "${each.value["name"]}",
      "set_pass"    = base64encode(split(".", "${module.phpipamModule[each.key].phpipam_main_ipv4_reserved}")[3]),
      "ip_main"     = "${module.phpipamModule[each.key].phpipam_main_ipv4_reserved}",
      "ip_bckp"     = "${module.phpipamModule[each.key].phpipam_bckp_ipv4_reserved}",
      "subnet_ip"   = "${module.phpipamModule[each.key].phpipam_subnet_addr}",
      "subnet_gw"   = "${module.phpipamModule[each.key].phpipam_subnet_gateway}",
      "subnet_mask" = "${module.phpipamModule[each.key].phpipam_subnet_mask}",
      "ns_ip"       = "${module.phpipamModule[each.key].phpipam_subnet_name_servers}",
      "user"        = "${var.tf_ssh_cred.user}",
      "pass"        = "${var.tf_ssh_cred.pass}"
    })
  }
}

resource "null_resource" "check_vm_ready" {
  for_each = var.vms
  provisioner "remote-exec" {
    on_failure = fail
    connection {
      host     = tomap(nutanix_virtual_machine.vm[each.key].nic_list_status[0].ip_endpoint_list[0]).ip
      user     = var.tf_ssh_cred.user
      password = var.tf_ssh_cred.pass
      port     = var.tf_ssh_cred.port
    }

    inline = ["while [ ! -f /tmp/terraform_go ]; do sleep 2; done"]
  }
}