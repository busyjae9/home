# Terraform 홈 서버 설정

이 디렉토리에는 홈 서버 인프라 관리를 위한 Terraform 설정이 포함되어 있습니다.

## 파일 구조

```plaintext
terraform/
├── main.tf                    # 메인 테라폼 설정
├── variables.tf               # 입력 변수 정의
├── outputs.tf                 # 출력값 정의
├── providers.tf               # 프로바이더 설정
├── versions.tf                # 버전 제약사항
├── terraform.tfvars.example   # 변수 값 예시 파일
├── modules/                   # 테라폼 모듈들
│   └── ssh-connect/           # SSH 연결 설정 모듈
│       └── main.tf
└── README.md                  # 이 파일
```

## 사용 방법

### 1. 사전 준비

```bash
# SSH 키 페어가 생성되어 있는지 확인
ls ~/.ssh/id_rsa*

# 없다면 SSH 키 생성
ssh-keygen -t rsa -b 4096 -C "your_email@example.com"
```

### 2. 초기 설정

```bash
# terraform.tfvars 파일 생성
cp terraform.tfvars.example terraform.tfvars

# terraform.tfvars 파일을 실제 서버 정보로 수정
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

### SSH 연결 설정
- `ssh.host`: 서버 IP 주소 또는 호스트명
- `ssh.user`: SSH 접속 사용자명
- `ssh.public_key_path`: SSH 공개키 파일 경로

### SSL 인증서 설정
- `acme_email`: SSL 인증서 발급용 이메일 주소

## 주의사항

- `terraform.tfvars` 파일은 SSH 접속 정보 등 민감한 정보를 포함하므로 Git에 커밋하지 마세요
- 대상 서버에 SSH 접근 권한이 있는지 확인하세요
- 리소스 변경 전에는 항상 `terraform plan`으로 변경사항을 먼저 확인하세요
- 홈 네트워크 환경이므로 로컬 백엔드를 사용합니다

## 현재 기능

이 Terraform 설정은 현재 다음 기능을 제공합니다:

- **SSH 키 설정**: 서버에 SSH 공개키를 자동으로 등록
- **서버 초기화**: SSH 접속을 위한 기본 설정

## 향후 확장 계획

추가로 필요한 인프라 리소스들은 별도 모듈이나 `.tf` 파일로 확장할 수 있습니다:

- Docker 컨테이너 배포
- Nginx 프록시 설정  
- SSL 인증서 관리
- 방화벽 규칙 설정
- 모니터링 도구 설치
