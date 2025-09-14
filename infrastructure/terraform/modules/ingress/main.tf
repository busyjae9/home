resource "kubernetes_namespace" "traefik" {
  metadata {
    name = var.ingress.namespace
    labels = {
      name = var.ingress.namespace
    }
  }
}

resource "tls_private_key" "traefik_ca" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "tls_self_signed_cert" "traefik_ca" {
  private_key_pem = tls_private_key.traefik_ca.private_key_pem

  subject {
    common_name  = "Traefik Local CA"
    organization = "Local Development"
  }

  validity_period_hours = 8760
  is_ca_certificate     = true

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "cert_signing",
  ]
}

resource "kubernetes_secret" "traefik_default_cert" {
  metadata {
    name      = var.ingress.default_cert_secret_name
    namespace = kubernetes_namespace.traefik.metadata[0].name
  }

  type = "kubernetes.io/tls"

  data = {
    "tls.crt" = tls_self_signed_cert.traefik_ca.cert_pem
    "tls.key" = tls_private_key.traefik_ca.private_key_pem
  }

  depends_on = [kubernetes_namespace.traefik]
}

resource "helm_release" "traefik" {
  name             = var.ingress.name
  repository       = "https://traefik.github.io/charts"
  chart            = "traefik"
  version          = var.ingress.chart_version
  namespace        = kubernetes_namespace.traefik.metadata[0].name
  create_namespace = false

  values = [
    templatefile("${path.module}/values.yaml.tpl", {
      node_port_http              = var.ingress.node_ports.http
      node_port_https             = var.ingress.node_ports.https
      dashboard_enabled           = var.ingress.dashboard.enabled
      dashboard_host              = var.ingress.dashboard.host
      default_cert_secret_name    = var.ingress.default_cert_secret_name
      dashboard_insecure_enabled  = var.ingress.dashboard.insecure
    })
  ]

  depends_on = [
    kubernetes_namespace.traefik,
    kubernetes_secret.traefik_default_cert
  ]
}