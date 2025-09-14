output "ingress_namespace" {
  description = "Traefik 네임스페이스 이름"
  value       = kubernetes_namespace.traefik.metadata[0].name
}

output "ingress_class_name" {
  description = "Traefik Ingress 클래스 이름"
  value       = "traefik"
}

output "helm_release_name" {
  description = "배포된 Helm 릴리즈 이름"
  value       = helm_release.traefik.name
}

output "helm_release_status" {
  description = "Helm 릴리즈 배포 상태"
  value       = helm_release.traefik.status
}

output "node_ports" {
  description = "Traefik NodePort 정보"
  value = {
    http  = var.ingress.node_ports.http
    https = var.ingress.node_ports.https
  }
}

output "dashboard_url" {
  description = "Traefik 대시보드 접속 URL"
  value       = var.ingress.dashboard.enabled ? "https://${var.ingress.dashboard.host}" : null
}

output "default_cert_secret" {
  description = "기본 TLS 인증서 시크릿 정보"
  value = {
    name      = kubernetes_secret.traefik_default_cert.metadata[0].name
    namespace = kubernetes_secret.traefik_default_cert.metadata[0].namespace
  }
}

output "ca_certificate" {
  description = "로컬 CA 인증서 (브라우저 신뢰 설정용)"
  value       = tls_self_signed_cert.traefik_ca.cert_pem
  sensitive   = false
}