# kube-prometheus-stack 테라폼 구현 가이드

## 개요

홈 서버 쿠버네티스 클러스터에 kube-prometheus-stack을 테라폼 Helm 프로바이더를 통해 배포하는 구현 가이드입니다.

## 1. 프로바이더 설정

### 1.1 필요한 프로바이더

```hcl
# providers.tf 업데이트
terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.17.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.8.0"
    }
  }
}

provider "kubernetes" {
  config_path = ".kube/config"
}

provider "helm" {
  kubernetes {
    config_path = ".kube/config"
  }
}
```

### 1.2 프로바이더 특징

- **Kubernetes Provider**: 쿠버네티스 리소스 직접 관리
- **Helm Provider**: Helm 차트 배포 및 관리
- **의존성 관리**: 테라폼이 자동으로 리소스 생성 순서 관리

## 2. 네임스페이스 구성

### 2.1 모니터링 네임스페이스 생성

```hcl
# monitoring.tf
resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = "monitoring"
    labels = {
      name = "monitoring"
      purpose = "prometheus-grafana-stack"
    }
  }
}
```

### 2.2 네임스페이스 설계

- **격리**: 모니터링 구성 요소를 별도 네임스페이스로 분리
- **보안**: RBAC 정책 적용 범위 제한
- **관리**: 리소스 그룹화로 운영 편의성 향상

## 3. kube-prometheus-stack 배포

### 3.1 기본 배포 구성

```hcl
resource "helm_release" "kube_prometheus_stack" {
  name       = "kube-prometheus-stack"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  namespace  = kubernetes_namespace.monitoring.metadata[0].name
  version    = "77.6.2"

  # 차트 업그레이드 설정
  force_update    = false
  recreate_pods   = false
  cleanup_on_fail = true
  wait            = true
  timeout         = 600

  depends_on = [kubernetes_namespace.monitoring]
}
```

### 3.2 고급 설정 (values.yaml 커스터마이징)

```hcl
resource "helm_release" "kube_prometheus_stack" {
  name       = "kube-prometheus-stack"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  namespace  = kubernetes_namespace.monitoring.metadata[0].name
  version    = "77.6.2"

  values = [
    yamlencode({
      # Prometheus 설정
      prometheus = {
        prometheusSpec = {
          # 데이터 보관 기간
          retention = "15d"
          
          # 스토리지 설정
          storageSpec = {
            volumeClaimTemplate = {
              spec = {
                storageClassName = "local-path"
                accessModes      = ["ReadWriteOnce"]
                resources = {
                  requests = {
                    storage = "20Gi"
                  }
                }
              }
            }
          }

          # 리소스 제한
          resources = {
            limits = {
              cpu    = "2000m"
              memory = "4Gi"
            }
            requests = {
              cpu    = "1000m"
              memory = "2Gi"
            }
          }
        }

        # 서비스 설정
        service = {
          type = "ClusterIP"
        }
      }

      # Grafana 설정
      grafana = {
        # 관리자 계정
        adminPassword = var.grafana_admin_password

        # 영구 저장소
        persistence = {
          enabled          = true
          storageClassName = "local-path"
          size             = "5Gi"
        }

        # 서비스 설정
        service = {
          type = "ClusterIP"
        }

        # 리소스 제한
        resources = {
          limits = {
            cpu    = "500m"
            memory = "1Gi"
          }
          requests = {
            cpu    = "250m"
            memory = "512Mi"
          }
        }

        # 기본 대시보드 설정
        defaultDashboardsEnabled = true
        defaultDashboardsTimezone = "Asia/Seoul"
      }

      # AlertManager 설정
      alertmanager = {
        alertmanagerSpec = {
          # 스토리지 설정
          storage = {
            volumeClaimTemplate = {
              spec = {
                storageClassName = "local-path"
                accessModes      = ["ReadWriteOnce"]
                resources = {
                  requests = {
                    storage = "5Gi"
                  }
                }
              }
            }
          }

          # 리소스 제한
          resources = {
            limits = {
              cpu    = "200m"
              memory = "512Mi"
            }
            requests = {
              cpu    = "100m"
              memory = "256Mi"
            }
          }
        }
      }

      # Node Exporter 설정
      nodeExporter = {
        enabled = true
      }

      # kube-state-metrics 설정
      kubeStateMetrics = {
        enabled = true
      }
    })
  ]

  depends_on = [kubernetes_namespace.monitoring]
}
```

## 4. 변수 및 출력값 설정

### 4.1 변수 정의

```hcl
# variables.tf에 추가
variable "grafana_admin_password" {
  description = "Grafana 관리자 비밀번호"
  type        = string
  sensitive   = true
}

variable "prometheus_retention" {
  description = "Prometheus 데이터 보관 기간"
  type        = string
  default     = "15d"
}

variable "prometheus_storage_size" {
  description = "Prometheus 스토리지 크기"
  type        = string
  default     = "20Gi"
}

variable "grafana_storage_size" {
  description = "Grafana 스토리지 크기"
  type        = string
  default     = "5Gi"
}
```

### 4.2 출력값 설정

```hcl
# outputs.tf에 추가
output "monitoring_namespace" {
  description = "모니터링 네임스페이스 이름"
  value       = kubernetes_namespace.monitoring.metadata[0].name
}

output "grafana_service" {
  description = "Grafana 서비스 정보"
  value = {
    name      = "kube-prometheus-stack-grafana"
    namespace = kubernetes_namespace.monitoring.metadata[0].name
    port      = 80
  }
}

output "prometheus_service" {
  description = "Prometheus 서비스 정보"
  value = {
    name      = "kube-prometheus-stack-prometheus"
    namespace = kubernetes_namespace.monitoring.metadata[0].name
    port      = 9090
  }
}

output "alertmanager_service" {
  description = "AlertManager 서비스 정보"
  value = {
    name      = "kube-prometheus-stack-alertmanager"
    namespace = kubernetes_namespace.monitoring.metadata[0].name
    port      = 9093
  }
}
```

## 5. 파일 구조 권장사항

### 5.1 추천 디렉토리 구조

```plaintext
infrastructure/terraform/
├── main.tf                    # 메인 모듈 호출
├── variables.tf               # 전역 변수
├── outputs.tf                 # 전역 출력값
├── providers.tf               # 프로바이더 설정
├── versions.tf                # 버전 제약사항
├── monitoring.tf              # 모니터링 관련 리소스
├── terraform.tfvars.example   # 변수 예시
└── modules/
    ├── ssh-connect/           # SSH 연결 모듈
    └── monitoring/            # 모니터링 모듈 (선택사항)
```

### 5.2 모듈화 옵션

별도 모듈로 분리하는 경우:

```plaintext
modules/monitoring/
├── main.tf          # kube-prometheus-stack 리소스
├── variables.tf     # 모듈 변수
├── outputs.tf       # 모듈 출력값
└── versions.tf      # 모듈 버전 요구사항
```

## 6. 배포 및 검증

### 6.1 배포 명령어

```bash
# 초기화
terraform init

# 계획 확인
terraform plan -var="grafana_admin_password=your-secure-password"

# 배포 실행
terraform apply -var="grafana_admin_password=your-secure-password"
```

### 6.2 배포 후 검증

```bash
# Pod 상태 확인
kubectl get pods -n monitoring

# 서비스 확인
kubectl get svc -n monitoring

# Grafana 접속 (포트 포워딩)
kubectl port-forward -n monitoring svc/kube-prometheus-stack-grafana 3000:80

# Prometheus 접속 (포트 포워딩)
kubectl port-forward -n monitoring svc/kube-prometheus-stack-prometheus 9090:9090
```

## 7. 주의사항 및 모범 사례

### 7.1 보안 고려사항

- **비밀번호 관리**: `grafana_admin_password`를 환경변수 또는 terraform.tfvars에서 관리
- **RBAC**: 기본 RBAC 설정 검토 및 필요시 추가 제한
- **네트워크 정책**: 네임스페이스 간 통신 제한 고려

### 7.2 리소스 최적화

- **홈랩 환경**: CPU/메모리 리소스 제한을 환경에 맞게 조정
- **스토리지**: 로컬 스토리지 사용시 노드 장애 대비 백업 전략 수립
- **보관 정책**: Prometheus 데이터 보관 기간을 스토리지 용량에 맞게 설정

### 7.3 운영 관리

- **업그레이드**: Helm 차트 버전 업그레이드시 호환성 확인
- **백업**: Grafana 대시보드 및 Prometheus 설정 백업
- **모니터링**: 모니터링 시스템 자체의 헬스 체크 설정

## 8. 트러블슈팅

### 8.1 일반적인 문제

1. **스토리지 클래스 없음**: `local-path` 스토리지 클래스가 없는 경우 기본값 사용
2. **리소스 부족**: 노드 리소스 부족시 Pod 스케줄링 실패
3. **포트 충돌**: 기존 서비스와 포트 충돌시 서비스 타입 변경

### 8.2 디버깅 명령어

```bash
# Helm 릴리즈 상태 확인
helm list -n monitoring

# 상세 Pod 정보 확인
kubectl describe pod -n monitoring <pod-name>

# 로그 확인
kubectl logs -n monitoring <pod-name> -c <container-name>
```

---

**작성일**: 2025-09-13  
**작성자**: 홈 서버 인프라 팀  
**버전**: 1.0
