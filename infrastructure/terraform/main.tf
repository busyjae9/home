module "ssh-connect" {
  source = "./modules/ssh-connect"

  ssh = var.ssh
}
