module "ingress" {
  source = "./modules/ingress"

  ingress = var.ingress

  depends_on = [
    module.ssh_connect
  ]
}