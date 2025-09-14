# Monitoring 모듈

kube-prometheus-stack을 사용한 쿠버네티스 모니터링 스택 배포 모듈입니다.

## 기능

- Prometheus: 메트릭 수집 및 저장
- Grafana: 메트릭 시각화 및 대시보드
- AlertManager: 알림 관리
- Node Exporter: 노드 메트릭 수집
- Kube State Metrics: 쿠버네티스 리소스 메트릭
- Ingress를 통한 외부 접근 지원

## 사용 예제

```terraform
module "monitoring" {
  source = "./modules/monitoring"

  monitoring = {
    name          = "monitoring-stack"
    namespace     = "monitoring"
    chart_version = "45.7.1"

    prometheus = {
      retention    = "30d"
      storage_size = "50Gi"
      ingress = {
        enabled    = true
        host       = "prometheus.example.com"
        class_name = "nginx"
      }
    }

    grafana = {
      admin_password = "your-secure-password"
      ingress = {
        enabled    = true
        host       = "grafana.example.com"
        class_name = "nginx"
        tls = {
          enabled     = true
          secret_name = "grafana-tls"
        }
      }
    }

    alertmanager = {
      ingress = {
        enabled    = true
        host       = "alertmanager.example.com"
        class_name = "nginx"
      }
    }
  }
}
```

## 출력값

- `monitoring_namespace`: 생성된 네임스페이스 이름
- `helm_release_name`: 배포된 Helm 릴리즈 이름
- `helm_release_status`: Helm 릴리즈 배포 상태
- `prometheus_service_name`: Prometheus 서비스 이름
- `grafana_service_name`: Grafana 서비스 이름
- `alertmanager_service_name`: AlertManager 서비스 이름
- `ingress_hosts`: 설정된 Ingress 호스트 정보

## 요구사항

- Kubernetes 클러스터
- Helm provider
- Ingress Controller (외부 접근 시)
- StorageClass: local-path (또는 설정 변경 필요)
