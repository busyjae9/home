# Terraform 설정

이 디렉토리에는 프로젝트의 인프라스트럭처를 관리하는 Terraform 설정이 포함되어 있습니다.

## 파일 구조

```
terraform/
├── main.tf                    # 메인 테라폼 설정 및 provider 설정
├── variables.tf               # 입력 변수 정의
├── outputs.tf                 # 출력값 정의
├── terraform.tfvars.example   # 변수 값 예시 파일
└── README.md                  # 이 파일
```

## 사용 방법

### 1. 초기 설정

```bash
# terraform.tfvars 파일 생성
cp terraform.tfvars.example terraform.tfvars

# terraform.tfvars 파일을 실제 값으로 수정
vi terraform.tfvars
```

### 2. Terraform 초기화

```bash
terraform init
```

### 3. 계획 확인

```bash
terraform plan
```

### 4. 인프라 배포

```bash
terraform apply
```

### 5. 인프라 제거

```bash
terraform destroy
```

## 주요 변수

- `project_name`: 프로젝트 이름
- `environment`: 환경 (dev, staging, prod)
- `aws_region`: AWS 리전
- `vpc_cidr`: VPC CIDR 블록
- `public_subnet_cidrs`: 퍼블릭 서브넷 CIDR 목록
- `private_subnet_cidrs`: 프라이빗 서브넷 CIDR 목록

## 주의사항

- `terraform.tfvars` 파일은 민감한 정보를 포함할 수 있으므로 Git에 커밋하지 마세요
- 프로덕션 환경에서는 반드시 S3 백엔드를 사용하여 상태 파일을 원격으로 관리하세요
- 리소스 변경 전에는 항상 `terraform plan`으로 변경사항을 먼저 확인하세요