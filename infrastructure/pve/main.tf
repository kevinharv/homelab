/*
    Entrypoint for all Proxmox homelab resources.
*/

module "dev_box" {
  source = "./modules/vm"

  vmid = 501
  name = "sdbxdev1"
  description = "Remote development box."
  template_name = "linux-ubuntu-24.04-lts-uefi"

  cloud_init_user = "user"
  cloud_init_password = "Testing123"
  cloud_init_ssh_key = file("~/.ssh/prox_lab.pub")

  vm_cidr = "192.168.1.22/24"
  network_gateway_cidr = "192.168.1.254"
  dns_server = "1.1.1.1"
}
