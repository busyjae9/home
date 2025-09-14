variable "acme_email" {
  description = "ACME email for SSL certificates"
  type        = string
}

variable "ssh" {
  description = "MAIN 서버 SSH 접속 정보"
  type = object({
    host            = string
    user            = string
    public_key_path = string
  })
}

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
}

variable "dns" {
  description = "DNS 서버 설정"
  type = object({
    namespace   = string
    target_node = string
    
    domains = list(object({
      name = string
      ip   = string
    }))
  })
}
