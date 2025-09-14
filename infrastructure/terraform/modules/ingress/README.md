# Ingress 모듈

Traefik을 사용한 Kubernetes Ingress Controller 배포 모듈입니다.

## 기능

- Traefik Ingress Controller 배포
- 로컬 개발용 자체 서명 TLS 인증서 자동 생성
- NodePort를 통한 외부 접근
- Traefik 대시보드 활성화
- 기본 Ingress 클래스 설정

## 사용 예제

```terraform
module "ingress" {
  source = "./modules/ingress"

  ingress = {
    name          = "traefik"
    namespace     = "traefik-system"
    chart_version = "24.0.0"
    default_cert_secret_name = "traefik-default-cert"

    node_ports = {
      http  = 30080
      https = 30443
    }

    dashboard = {
      enabled  = true
      host     = "traefik.local"
      insecure = false
    }
  }
}
```

## 접속 방법

### 1. /etc/hosts 설정

로컬에서 접속하려면 `/etc/hosts` 파일에 다음을 추가:

```plaintext
127.0.0.1 traefik.local
127.0.0.1 grafana.local
127.0.0.1 prometheus.local
```

### 2. 브라우저에서 접속

- Traefik 대시보드: `https://traefik.local:30443`
- 다른 서비스들: 각각 설정한 호스트:30443

### 3. 인증서 경고 해결

브라우저에서 "안전하지 않음" 경고가 나타나면:

- Chrome/Edge: "고급" → "안전하지 않은 사이트로 이동"
- Firefox: "고급" → "위험을 감수하고 계속"

또는 CA 인증서를 브라우저에 등록 (선택사항):

1. `terraform output -json | jq -r .ca_certificate.value > ca.crt`
2. 브라우저 설정에서 인증서 가져오기

## 출력값

- `ingress_namespace`: Traefik 네임스페이스
- `ingress_class_name`: Ingress 클래스 이름 (traefik)
- `node_ports`: HTTP/HTTPS NodePort 번호
- `dashboard_url`: Traefik 대시보드 URL
- `ca_certificate`: CA 인증서 (브라우저 등록용)

## 요구사항

- Kubernetes 클러스터
- Helm provider
- TLS provider (자동 생성됨)
