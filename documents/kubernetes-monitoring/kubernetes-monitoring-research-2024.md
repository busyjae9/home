# 쿠버네티스 모니터링 시스템 조사 리포트 (2024)

## 개요

홈 서버 환경에서 쿠버네티스 클러스터 모니터링 시스템 구축을 위한 기술 조사 및 아키텍처 분석 리포트입니다.

## 1. 쿠버네티스 모니터링 시스템 종류

### 1.1 Prometheus + Grafana (표준 조합)

**특징:**

- Prometheus: CNCF 졸업 프로젝트 (2018년)로 쿠버네티스 환경의 사실상 표준
- Grafana: Prometheus에서 권장하는 시각화 도구
- 동적 서비스 디스커버리 지원
- Pull 방식 메트릭 수집

**장점:**

- 쿠버네티스 네이티브 지원
- CNCF 관리로 안정성 보장
- 강력한 시계열 데이터 처리
- 활발한 커뮤니티 지원

**단점:**

- 별도 구성 요소 설치 필요
- 초기 설정 복잡성

### 1.2 kube-prometheus-stack

**특징:**

- Prometheus + Grafana + AlertManager + Exporters 통합 패키지
- Helm 차트로 간단 설치
- 쿠버네티스 클러스터 전용 최적화
- 사전 구성된 대시보드 및 알림 규칙 포함

**구성 요소:**

- Prometheus Operator
- Grafana 대시보드
- AlertManager
- Node Exporter
- kube-state-metrics
- Prometheus Rules

**장점:**

- 원클릭 설치 가능
- 즉시 사용 가능한 설정
- 유지보수 부담 최소화
- 홈랩 환경에 이상적

### 1.3 ELK Stack (Elasticsearch + Logstash + Kibana)

**특징:**

- 로그 중심 모니터링 시스템
- 전문 텍스트 인덱싱
- 강력한 검색 기능
- 상세한 로그 분석

**장점:**

- 복잡한 로그 분석 가능
- 유연한 커스터마이징
- 광범위한 데이터 소스 지원

**단점:**

- 높은 리소스 요구사항
- 복잡한 구성 및 관리
- 홈랩 환경에는 과도한 성능

### 1.4 Grafana Loki

**특징:**

- Prometheus 아키텍처 영감
- 메타데이터만 인덱싱
- 효율적인 저장공간 사용
- Prometheus와 자연스러운 통합

**장점:**

- 저장 효율성
- 낮은 운영 오버헤드
- Prometheus 기반 환경 적합

**단점:**

- 제한적인 검색 기능
- ELK 대비 분석 능력 부족

## 2. 모니터링 아키텍처 구조

### 2.1 홈랩 권장 아키텍처

```plaintext
┌─────────────────────────────────────┐
│          Grafana Dashboard          │ ← 시각화 레이어
├─────────────────────────────────────┤
│           Prometheus                │ ← 메트릭 수집 & 저장
├─────────────────────────────────────┤
│          AlertManager              │ ← 알람 관리
├─────────────────────────────────────┤
│  Node Exporter | kube-state-metrics │ ← 메트릭 노출
├─────────────────────────────────────┤
│          Kubernetes Nodes           │ ← 인프라 레이어
└─────────────────────────────────────┘
```

### 2.2 핵심 구성 요소

#### Prometheus

- **역할**: 메트릭 수집 및 시계열 데이터 저장
- **특징**: 60초 간격 스크랩, 동적 타겟 디스커버리
- **데이터 보관**: 기본 15일 (설정 가능)

#### Grafana

- **역할**: 대시보드 및 시각화
- **특징**: Prometheus 데이터소스 연동
- **주요 대시보드**: 클러스터 개요, 노드 메트릭, Pod 리소스

#### AlertManager

- **역할**: 알림 규칙 관리 및 통지
- **지원 채널**: 이메일, Slack, 웹훅 등
- **기능**: 알림 그룹화, 중복 제거, 라우팅

#### Node Exporter

- **역할**: 노드 리소스 메트릭 수집
- **메트릭**: CPU, 메모리, 디스크, 네트워크
- **설치**: DaemonSet으로 각 노드에 배포

#### kube-state-metrics

- **역할**: 쿠버네티스 오브젝트 상태 메트릭
- **메트릭**: Pod, Deployment, Service 상태
- **데이터**: API 서버에서 직접 수집

#### cAdvisor

- **역할**: 컨테이너 메트릭 수집
- **특징**: kubelet에 내장
- **메트릭**: 컨테이너 리소스 사용률

### 2.3 모니터링 스코프

#### 클러스터 레벨

- 전체 클러스터 CPU/메모리/스토리지 사용률
- 노드 상태 및 가용성
- 네트워크 트래픽 통계

#### 워크로드 레벨

- Pod 리소스 요청/제한 vs 실제 사용률
- 컨테이너 상태 및 재시작 횟수
- 서비스 엔드포인트 상태

#### 애플리케이션 레벨

- 애플리케이션별 메트릭
- 비즈니스 로직 모니터링
- 커스텀 메트릭 수집

## 3. 2024년 트렌드 및 모범 사례

### 3.1 GitOps 통합

- ArgoCD를 통한 자동 배포 관리
- Git 저장소 기반 설정 관리
- Infrastructure as Code 적용

### 3.2 클라우드 네이티브 특성

- Kubernetes Operator 패턴 활용
- 선언적 설정 관리
- 자동 확장 및 자가 복구

### 3.3 리소스 효율성

- OpenCost 기반 비용 모니터링
- 리소스 최적화 권장사항
- 작은 클러스터 환경 최적화

### 3.4 보안 강화

- RBAC 기반 접근 제어
- TLS 암호화 통신
- 메트릭 데이터 보안

## 4. 홈 서버 환경 권장사항

### 4.1 추천 스택: kube-prometheus-stack

**선택 이유:**

- 설치 및 설정 간소화
- 검증된 설정으로 안정성 확보
- 홈랩 환경에 적합한 리소스 사용량
- 종합적인 모니터링 기능 제공

### 4.2 최소 요구사항

- **CPU**: 2 코어 이상
- **메모리**: 4GB 이상
- **스토리지**: 20GB 이상 (메트릭 저장용)
- **네트워크**: 안정적인 내부 네트워크

### 4.3 구현 우선순위

1. **Phase 1**: kube-prometheus-stack 기본 설치
2. **Phase 2**: 커스텀 대시보드 구성
3. **Phase 3**: 알림 규칙 설정
4. **Phase 4**: 로그 모니터링 추가 (선택사항)

## 5. 다음 단계

1. **기술 스택 최종 결정**
2. **Terraform 모듈 설계**
3. **Helm 차트 커스터마이징**
4. **모니터링 대시보드 설계**
5. **알림 정책 정의**

## 참고 자료

- [CNCF Prometheus](https://prometheus.io/)
- [kube-prometheus-stack Helm Chart](https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack)
- [Grafana Kubernetes Monitoring](https://grafana.com/solutions/kubernetes/)
- [Kubernetes Monitoring Best Practices](https://kubernetes.io/docs/tasks/debug/debug-cluster/resource-usage-monitoring/)

---

**작성일**: 2025-09-13  
**작성자**: 홈 서버 인프라 팀  
**버전**: 1.0
