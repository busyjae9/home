output "dns_namespace" {
  description = "DNS 네임스페이스 이름"
  value       = kubernetes_namespace.dns.metadata[0].name
}

output "dns_server_ip" {
  description = "DNS 서버 IP 주소"
  value       = var.ssh.host
}

output "dns_port" {
  description = "DNS 서버 포트"
  value       = 53
}

output "configured_domains" {
  description = "설정된 도메인 목록"
  value       = var.dns.domains
}

output "deployment_name" {
  description = "dnsmasq 배포 이름"
  value       = kubernetes_deployment.dnsmasq.metadata[0].name
}