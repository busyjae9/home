# 프로젝트 기본 변수
variable "project_name" {
  description = "프로젝트 이름"
  type        = string
  default     = "my-project"
}

variable "environment" {
  description = "환경 (dev, staging, prod)"
  type        = string
  default     = "dev"
  
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "환경은 dev, staging, prod 중 하나여야 합니다."
  }
}

# Kubernetes 관련 변수
variable "kubeconfig_path" {
  description = "kubeconfig 파일 경로"
  type        = string
  default     = "~/.kube/config"
}

variable "kube_context" {
  description = "사용할 Kubernetes context"
  type        = string
  default     = "default"
}

variable "namespace" {
  description = "기본 네임스페이스"
  type        = string
  default     = "default"
}

# 애플리케이션 관련 변수
variable "app_replicas" {
  description = "애플리케이션 복제본 수"
  type        = number
  default     = 3
}

variable "app_image" {
  description = "애플리케이션 Docker 이미지"
  type        = string
  default     = "nginx:latest"
}

variable "app_port" {
  description = "애플리케이션 포트"
  type        = number
  default     = 80
}

# 리소스 제한 변수
variable "cpu_request" {
  description = "CPU 요청량"
  type        = string
  default     = "100m"
}

variable "memory_request" {
  description = "메모리 요청량"
  type        = string
  default     = "128Mi"
}

variable "cpu_limit" {
  description = "CPU 제한량"
  type        = string
  default     = "500m"
}

variable "memory_limit" {
  description = "메모리 제한량"
  type        = string
  default     = "512Mi"
}

# 공통 레이블
variable "common_labels" {
  description = "모든 리소스에 적용할 공통 레이블"
  type        = map(string)
  default     = {}
}