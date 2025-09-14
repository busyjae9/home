resource "helm_release" "kube_prometheus_stack" {
  name             = var.monitoring.name
  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = "kube-prometheus-stack"
  version          = var.monitoring.chart_version
  namespace        = var.monitoring.namespace
  create_namespace = true

  values = [
    templatefile("${path.module}/values.yaml.tpl", {
      prometheus_retention         = var.monitoring.prometheus.retention
      prometheus_storage_size      = var.monitoring.prometheus.storage_size
      grafana_admin_password       = var.monitoring.grafana.admin_password
      grafana_ingress_enabled      = var.monitoring.grafana.ingress.enabled
      grafana_ingress_host         = var.monitoring.grafana.ingress.host
      grafana_ingress_class        = var.monitoring.grafana.ingress.class_name
      grafana_ingress_tls_enabled  = var.monitoring.grafana.ingress.tls.enabled
      grafana_ingress_secret_name  = var.monitoring.grafana.ingress.tls.secret_name
      alertmanager_ingress_enabled = var.monitoring.alertmanager.ingress.enabled
      alertmanager_ingress_host    = var.monitoring.alertmanager.ingress.host
      alertmanager_ingress_class   = var.monitoring.alertmanager.ingress.class_name
      prometheus_ingress_enabled   = var.monitoring.prometheus.ingress.enabled
      prometheus_ingress_host      = var.monitoring.prometheus.ingress.host
      prometheus_ingress_class     = var.monitoring.prometheus.ingress.class_name
    })
  ]

  depends_on = [
    kubernetes_namespace.monitoring
  ]
}

resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = var.monitoring.namespace
    labels = {
      name = var.monitoring.namespace
    }
  }
}