# 쿠버네티스 서비스 타입 및 접근 방법 가이드

## 개요

쿠버네티스에서 애플리케이션에 접근하는 다양한 방법과 각각의 특징, 장단점을 비교 분석한 문서입니다. 특히 홈랩 환경에서 Grafana, Prometheus 등 모니터링 도구에 접근하는 최적의 방법을 제시합니다.

## 1. 쿠버네티스 서비스 타입 비교

### 1.1 ClusterIP (기본 타입)

#### 정의

- 클러스터 내부 IP로만 서비스 노출
- 클러스터 외부에서는 직접 접근 불가능
- 지정하지 않을 경우 기본값

#### 특징

```yaml
service:
  type: ClusterIP
  clusterIP: 10.96.0.1  # 자동 할당
```

#### 장점

- **보안성**: 외부 인터넷에서 직접 접근 불가
- **리소스 효율성**: 추가 로드밸런서나 외부 IP 불필요
- **내부 통신**: Pod 간 안정적인 통신 제공

#### 단점

- **외부 접근 제한**: 클러스터 외부에서 직접 접근 불가능
- **추가 도구 필요**: 외부 접근시 포트포워딩 등 별도 방법 필요

### 1.2 NodePort

#### 정의

- 모든 노드의 특정 포트(30000-32767)로 서비스 노출
- ClusterIP 기능을 포함하여 구성

#### 특징

```yaml
service:
  type: NodePort
  nodePort: 32001  # 30000-32767 범위
  port: 80         # 서비스 포트
  targetPort: 3000 # Pod 포트
```

#### 장점

- **직접 외부 접근**: `<NodeIP>:<NodePort>`로 접근 가능
- **클라우드 독립적**: 어떤 환경에서도 작동
- **간단한 설정**: 복잡한 네트워크 구성 불필요

#### 단점

- **포트 제한**: 30000-32767 범위로 제한
- **보안 취약점**: 모든 노드에 포트 개방
- **포트 관리**: 여러 서비스 사용시 포트 충돌 가능성

### 1.3 LoadBalancer

#### 정의

- 외부 로드밸런서를 통한 서비스 노출
- NodePort와 ClusterIP 기능 포함

#### 특징

```yaml
service:
  type: LoadBalancer
  ports:
  - port: 80
    targetPort: 3000
```

#### 장점

- **자동 로드 분산**: 트래픽을 여러 노드에 자동 분배
- **고가용성**: 노드 장애시 자동 트래픽 재라우팅
- **고유 IP**: 외부에서 접근 가능한 고유 공인 IP 제공

#### 단점

- **클라우드 의존**: 클라우드 프로바이더 지원 필요
- **비용**: 클라우드에서 추가 비용 발생
- **홈랩 제한**: 일반적으로 홈랩 환경에서 지원되지 않음

### 1.4 Ingress (서비스 타입이 아닌 라우팅 메커니즘)

#### 정의

- HTTP/HTTPS 트래픽을 클러스터 내부 서비스로 라우팅
- 여러 서비스를 단일 진입점으로 통합

#### 특징

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: monitoring-ingress
spec:
  rules:
  - host: grafana.homelab.local
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: kube-prometheus-stack-grafana
            port:
              number: 80
  - host: prometheus.homelab.local
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: kube-prometheus-stack-prometheus
            port:
              number: 9090
```

#### 장점

- **도메인 기반 라우팅**: 의미있는 도메인으로 접근
- **SSL 종료**: TLS/SSL 인증서 자동 관리 가능
- **다중 서비스 통합**: 하나의 진입점으로 여러 서비스 관리
- **경로 기반 라우팅**: URL 경로에 따른 세밀한 라우팅

#### 단점

- **Ingress Controller 필요**: 별도 컨트롤러 설치 필요
- **복잡성**: 설정 및 관리 복잡도 증가
- **L7 제한**: HTTP/HTTPS 트래픽만 지원

## 2. 서비스 타입별 비교표

| 서비스 타입 | 접근 레벨 | 외부 접근 | 클라우드 의존 | 홈랩 적합성 | 사용 사례 |
|-------------|-----------|-----------|---------------|-------------|-----------|
| **ClusterIP** | 내부만 | ❌ | ❌ | ⭐⭐⭐⭐⭐ | Pod 간 통신, 개발/테스트 |
| **NodePort** | 외부 가능 | ✅ | ❌ | ⭐⭐⭐⭐ | 간단한 외부 노출 |
| **LoadBalancer** | 외부 가능 | ✅ | ✅ | ⭐⭐ | 프로덕션 외부 접근 |
| **Ingress** | 외부 가능 | ✅ | 컨트롤러에 따라 | ⭐⭐⭐⭐⭐ | 고급 라우팅, SSL |

## 3. 포트포워딩 사용 이유와 특징

### 3.1 포트포워딩이란?

kubectl port-forward는 로컬 포트를 쿠버네티스 클러스터 내부의 Pod나 Service로 연결하는 기능입니다.

```bash
# 기본 사용법
kubectl port-forward -n monitoring svc/kube-prometheus-stack-grafana 3000:80

# Pod에 직접 연결
kubectl port-forward -n monitoring pod/grafana-pod-name 3000:3000
```

### 3.2 포트포워딩 사용 이유

#### 1. 보안성

- 서비스를 외부에 직접 노출하지 않음
- 클러스터 내부에서만 접근 가능한 상태 유지
- 외부 공격 표면 최소화

#### 2. 간편성

- 복잡한 네트워크 설정 불필요
- kubectl 명령어 하나로 즉시 접근 가능
- 홈랩 환경에서 빠른 테스트 가능

#### 3. 임시 접근

- 개발/디버깅 목적의 일시적 접근
- 터미널 종료시 자동으로 연결 해제

### 3.3 포트포워딩의 장단점

#### 장점

- **즉시 사용**: 복잡한 설정 없이 바로 접근
- **보안**: 로컬에서만 접근 가능
- **유연성**: 필요할 때만 연결
- **디버깅 친화적**: 개발 및 문제 해결에 이상적

#### 단점

- **일시적**: 터미널 세션 종료시 연결 끊김
- **단일 사용자**: 한 번에 하나의 로컬 포트만 사용
- **성능 제한**: 대용량 트래픽에 적합하지 않음
- **지속성 부족**: 자동화된 접근에는 부적합

## 4. 홈랩 환경별 권장 접근 방법

### 4.1 개발 및 테스트 단계

#### 추천: ClusterIP + Port-forward

```bash
# Grafana 접속
kubectl port-forward -n monitoring svc/kube-prometheus-stack-grafana 3000:80

# Prometheus 접속
kubectl port-forward -n monitoring svc/kube-prometheus-stack-prometheus 9090:9090

# AlertManager 접속
kubectl port-forward -n monitoring svc/kube-prometheus-stack-alertmanager 9093:9093
```

#### 장점

안전하고 간단, 즉시 사용 가능

### 4.2 지속적 사용 (개인 접근)

#### 추천: NodePort

```yaml
grafana:
  service:
    type: NodePort
    nodePort: 32001

prometheus:
  service:
    type: NodePort  
    nodePort: 32002
```

#### 접근 방법

`http://<노드IP>:32001`

### 4.3 전문적인 홈랩 환경

#### 추천: Ingress + 로컬 DNS

```yaml
# Ingress 설정
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: monitoring-ingress
  annotations:
    kubernetes.io/ingress.class: "nginx"
    cert-manager.io/cluster-issuer: "letsencrypt-prod"
spec:
  tls:
  - hosts:
    - grafana.homelab.local
    - prometheus.homelab.local
    secretName: monitoring-tls
  rules:
  - host: grafana.homelab.local
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: kube-prometheus-stack-grafana
            port:
              number: 80
  - host: prometheus.homelab.local
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: kube-prometheus-stack-prometheus
            port:
              number: 9090
```

#### 로컬 DNS 설정 (`/etc/hosts` 또는 Pi-hole)

```plaintext
192.168.1.100 grafana.homelab.local
192.168.1.100 prometheus.homelab.local
```

### 4.4 가족/팀 공유 환경

#### 추천: LoadBalancer (MetalLB 사용)

```yaml
# MetalLB 설치 후
apiVersion: v1
kind: Service
metadata:
  name: grafana-lb
spec:
  type: LoadBalancer
  loadBalancerIP: 192.168.1.200
  ports:
  - port: 80
    targetPort: 3000
  selector:
    app.kubernetes.io/name: grafana
```

## 5. 실제 구현 예시

### 5.1 단계별 구현

#### 1단계: 기본 ClusterIP 설정

```hcl
# Terraform 설정
grafana = {
  service = {
    type = "ClusterIP"  # 기본값
  }
}
```

#### 2단계: 포트포워딩으로 접근 테스트

```bash
kubectl port-forward -n monitoring svc/kube-prometheus-stack-grafana 3000:80 &
```

#### 3단계: 지속적 접근을 위한 NodePort 변경

```hcl
grafana = {
  service = {
    type = "NodePort"
    nodePort = 32001
  }
}
```

#### 4단계: Ingress를 통한 도메인 접근

```bash
# NGINX Ingress Controller 설치
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/baremetal/deploy.yaml
```

### 5.2 각 방법의 트레이드오프

| 방법 | 보안 | 편의성 | 지속성 | 복잡도 | 홈랩 적합성 |
|------|------|--------|--------|--------|-------------|
| **ClusterIP + Port-forward** | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐ | ⭐ | ⭐⭐⭐⭐⭐ |
| **NodePort** | ⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐ | ⭐⭐⭐⭐ |
| **Ingress** | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| **LoadBalancer** | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐ |

## 6. 보안 고려사항

### 6.1 ClusterIP + Port-forward

- **장점**: 외부 노출 없음, 로컬에서만 접근
- **주의사항**: kubectl 권한 관리 중요

### 6.2 NodePort

#### 보안 설정

```yaml
# Network Policy로 접근 제한
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: grafana-access
spec:
  podSelector:
    matchLabels:
      app.kubernetes.io/name: grafana
  policyTypes:
  - Ingress
  ingress:
  - from:
    - ipBlock:
        cidr: 192.168.1.0/24  # 홈 네트워크만 허용
```

### 6.3 Ingress

#### TLS 설정

```yaml
spec:
  tls:
  - hosts:
    - grafana.homelab.local
    secretName: grafana-tls
```

#### 인증 설정

```yaml
metadata:
  annotations:
    nginx.ingress.kubernetes.io/auth-type: basic
    nginx.ingress.kubernetes.io/auth-secret: basic-auth
```

## 7. 결론 및 권장사항

### 7.1 홈랩 환경 단계별 접근

#### 시작 단계: ClusterIP + Port-forward

- 학습과 실험에 최적
- 보안성과 단순성의 균형

#### 성장 단계: NodePort

- 지속적 접근이 필요할 때
- 가족/친구와 공유시

#### 고급 단계: Ingress

- 전문적인 홈랩 운영
- 여러 서비스 통합 관리

### 7.2 최종 권장사항

홈랩 환경에서는 **ClusterIP + 포트포워딩**이 보안성과 단순성의 최적 균형을 제공합니다. 필요에 따라 NodePort나 Ingress로 점진적 발전이 가능하며, 각각의 장단점을 이해하고 환경에 맞는 선택을 하는 것이 중요합니다.

---

**작성일**: 2025-09-13  
**작성자**: 홈 서버 인프라 팀  
**버전**: 1.0
