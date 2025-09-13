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
