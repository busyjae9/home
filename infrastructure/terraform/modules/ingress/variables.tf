variable "ingress" {
  description = "Traefik Ingress Controller 설정"
  type = object({
    name          = string
    namespace     = string
    chart_version = string
    default_cert_secret_name = string
    
    node_ports = object({
      http  = number
      https = number
    })

    dashboard = object({
      enabled  = bool
      host     = string
      insecure = bool
    })
  })

  validation {
    condition     = can(regex("^[a-z0-9]([-a-z0-9]*[a-z0-9])?$", var.ingress.namespace))
    error_message = "네임스페이스는 소문자, 숫자, 하이픈만 사용 가능합니다."
  }

  validation {
    condition     = var.ingress.node_ports.http >= 30000 && var.ingress.node_ports.http <= 32767
    error_message = "HTTP NodePort는 30000-32767 범위여야 합니다."
  }

  validation {
    condition     = var.ingress.node_ports.https >= 30000 && var.ingress.node_ports.https <= 32767
    error_message = "HTTPS NodePort는 30000-32767 범위여야 합니다."
  }

  validation {
    condition     = var.ingress.node_ports.http != var.ingress.node_ports.https
    error_message = "HTTP와 HTTPS NodePort는 서로 달라야 합니다."
  }
}