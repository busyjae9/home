output "monitoring_namespace" {
  description = "모니터링 네임스페이스 이름"
  value       = kubernetes_namespace.monitoring.metadata[0].name
}

output "helm_release_name" {
  description = "배포된 Helm 릴리즈 이름"
  value       = helm_release.kube_prometheus_stack.name
}

output "helm_release_status" {
  description = "Helm 릴리즈 배포 상태"
  value       = helm_release.kube_prometheus_stack.status
}

output "prometheus_service_name" {
  description = "Prometheus 서비스 이름"
  value       = "${helm_release.kube_prometheus_stack.name}-prometheus"
}

output "grafana_service_name" {
  description = "Grafana 서비스 이름"
  value       = "${helm_release.kube_prometheus_stack.name}-grafana"
}

output "alertmanager_service_name" {
  description = "AlertManager 서비스 이름"
  value       = "${helm_release.kube_prometheus_stack.name}-alertmanager"
}

output "ingress_hosts" {
  description = "설정된 Ingress 호스트 정보"
  value = {
    prometheus   = var.monitoring.prometheus.ingress.enabled ? var.monitoring.prometheus.ingress.host : null
    grafana      = var.monitoring.grafana.ingress.enabled ? var.monitoring.grafana.ingress.host : null
    alertmanager = var.monitoring.alertmanager.ingress.enabled ? var.monitoring.alertmanager.ingress.host : null
  }
}