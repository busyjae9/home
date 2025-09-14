variable "monitoring" {
  description = "모니터링 스택 설정"
  type = object({
    name          = string
    namespace     = string
    chart_version = string
    
    prometheus = object({
      retention    = string
      storage_size = string
      ingress = object({
        enabled    = bool
        host       = string
        class_name = string
      })
    })

    grafana = object({
      admin_password = string
      ingress = object({
        enabled    = bool
        host       = string
        class_name = string
        tls = object({
          enabled     = bool
          secret_name = string
        })
      })
    })

    alertmanager = object({
      ingress = object({
        enabled    = bool
        host       = string
        class_name = string
      })
    })
  })

  validation {
    condition     = can(regex("^[a-z0-9]([-a-z0-9]*[a-z0-9])?$", var.monitoring.namespace))
    error_message = "네임스페이스는 소문자, 숫자, 하이픈만 사용 가능합니다."
  }

  validation {
    condition     = can(regex("^[0-9]+\\.[0-9]+\\.[0-9]+$", var.monitoring.chart_version))
    error_message = "차트 버전은 semantic version 형식이어야 합니다 (예: 1.0.0)."
  }
}