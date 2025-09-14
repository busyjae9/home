variable "ssh" {
  description = "SSH 접속 정보"
  type = object({
    host            = string
    user            = string
    public_key_path = string
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

  validation {
    condition     = can(regex("^[a-z0-9]([-a-z0-9]*[a-z0-9])?$", var.dns.namespace))
    error_message = "네임스페이스는 소문자, 숫자, 하이픈만 사용 가능합니다."
  }

  validation {
    condition     = length(var.dns.domains) > 0
    error_message = "최소 하나 이상의 도메인이 필요합니다."
  }
}