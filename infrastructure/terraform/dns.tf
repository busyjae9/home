module "dns" {
  source = "./modules/dns"

  ssh = var.ssh
  dns = var.dns

  depends_on = [
    module.ssh_connect
  ]
}