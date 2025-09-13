# 메인 테라폼 설정
terraform {
  required_version = ">= 1.0"

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.20"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.10"
    }
  }

  # 로컬 백엔드 사용 (원격 백엔드 필요시 수정)
  # backend "local" {
  #   path = "terraform.tfstate"
  # }
}

# Kubernetes Provider 설정
provider "kubernetes" {
  config_path    = var.kubeconfig_path
  config_context = var.kube_context
}

# Helm Provider 설정
provider "helm" {
  kubernetes {
    config_path    = var.kubeconfig_path
    config_context = var.kube_context
  }
}