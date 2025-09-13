# 프로젝트 정보 출력
output "project_name" {
  description = "프로젝트 이름"
  value       = var.project_name
}

output "environment" {
  description = "환경"
  value       = var.environment
}

output "namespace" {
  description = "사용 중인 네임스페이스"
  value       = var.namespace
}

output "kube_context" {
  description = "사용 중인 Kubernetes context"
  value       = var.kube_context
}

# Kubernetes 리소스 관련 출력 (리소스 생성 시 주석 해제)
# output "deployment_name" {
#   description = "Deployment 이름"
#   value       = kubernetes_deployment.app.metadata[0].name
# }

# output "service_name" {
#   description = "Service 이름"
#   value       = kubernetes_service.app.metadata[0].name
# }

# output "service_cluster_ip" {
#   description = "Service Cluster IP"
#   value       = kubernetes_service.app.spec[0].cluster_ip
# }

# output "configmap_name" {
#   description = "ConfigMap 이름"
#   value       = kubernetes_config_map.app.metadata[0].name
# }

# output "secret_name" {
#   description = "Secret 이름"
#   value       = kubernetes_secret.app.metadata[0].name
# }

# 추가 Kubernetes 리소스 출력값은 필요에 따라 여기에 추가