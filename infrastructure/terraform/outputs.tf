output "ingress_namespace" {
  description = "Traefik 네임스페이스 이름"
  value       = module.ingress.ingress_namespace
}

output "ingress_class_name" {
  description = "Traefik Ingress 클래스 이름"
  value       = module.ingress.ingress_class_name
}

output "ingress_node_ports" {
  description = "Traefik NodePort 정보"
  value       = module.ingress.node_ports
}

output "traefik_dashboard_url" {
  description = "Traefik 대시보드 접속 URL"
  value       = module.ingress.dashboard_url
}

output "ca_certificate" {
  description = "로컬 CA 인증서 (브라우저 신뢰 설정용)"
  value       = module.ingress.ca_certificate
  sensitive   = false
}

output "dns_server_ip" {
  description = "내부 DNS 서버 IP 주소"
  value       = module.dns.dns_server_ip
}

output "dns_configured_domains" {
  description = "설정된 DNS 도메인 목록"
  value       = module.dns.configured_domains
}