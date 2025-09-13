# Terraform Kubernetes 설정

이 디렉토리에는 홈 Kubernetes 클러스터의 인프라스트럭처를 관리하는 Terraform 설정이 포함되어 있습니다.

## 파일 구조

```plaintext
terraform/
├── main.tf                    # 메인 테라폼 설정 및 Kubernetes provider 설정
├── variables.tf               # 입력 변수 정의
├── outputs.tf                 # 출력값 정의
├── terraform.tfvars.example   # 변수 값 예시 파일
└── README.md                  # 이 파일
```

## 사용 방법

### 1. 사전 준비

```bash
# kubectl이 설치되어 있고 클러스터에 접근 가능한지 확인
kubectl cluster-info

# 사용 가능한 context 확인
kubectl config get-contexts
```

### 2. 초기 설정

```bash
# terraform.tfvars 파일 생성
cp terraform.tfvars.example terraform.tfvars

# terraform.tfvars 파일을 실제 값으로 수정
vi terraform.tfvars
```

### 3. Terraform 초기화

```bash
terraform init
```

### 4. 계획 확인

```bash
terraform plan
```

### 5. 인프라 배포

```bash
terraform apply
```

### 6. 인프라 제거

```bash
terraform destroy
```

## 주요 변수

- `project_name`: 프로젝트 이름
- `environment`: 환경 (dev, staging, prod)
- `kubeconfig_path`: kubeconfig 파일 경로
- `kube_context`: 사용할 Kubernetes context
- `namespace`: 기본 네임스페이스
- `app_replicas`: 애플리케이션 복제본 수
- `app_image`: Docker 이미지
- `cpu_request/limit`: CPU 리소스 설정
- `memory_request/limit`: 메모리 리소스 설정

## 주의사항

- `terraform.tfvars` 파일은 민감한 정보를 포함할 수 있으므로 Git에 커밋하지 마세요
- Kubernetes 클러스터에 접근 권한이 있는지 확인하세요
- 리소스 변경 전에는 항상 `terraform plan`으로 변경사항을 먼저 확인하세요
- 홈 네트워크의 Kubernetes 클러스터를 사용하므로 로컬 백엔드를 사용합니다

## 추가 리소스 생성

기본 설정 외에 추가로 필요한 Kubernetes 리소스들은 별도 `.tf` 파일로 생성하여 관리할 수 있습니다:

- `deployments.tf`: Deployment 리소스
- `services.tf`: Service 리소스  
- `configmaps.tf`: ConfigMap 리소스
- `secrets.tf`: Secret 리소스
- `ingress.tf`: Ingress 리소스
