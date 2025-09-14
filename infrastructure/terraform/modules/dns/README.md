# DNS 모듈

Kubernetes 클러스터에서 hostNetwork 모드로 dnsmasq를 실행하여 내부 DNS 서버를 구축하는 모듈입니다.

## 기능

- dnsmasq를 Kubernetes Pod로 배포 (hostNetwork 모드)
- 표준 53 포트에서 DNS 서비스 제공
- 로컬 도메인 설정 및 외부 DNS 포워딩
- 내부망에서 사용할 수 있는 DNS 서버 구축

## 사용 예제

```terraform
module "dns" {
  source = "./modules/dns"

  ssh = {
    host            = "192.168.0.41"
    user            = "seaweeds"
    public_key_path = "~/.ssh/id_rsa.pub"
  }

  dns = {
    namespace   = "dns-system"
    target_node = "main-server"
    
    domains = [
      {
        name = "traefik.local"
        ip   = "192.168.0.41"
      },
      {
        name = "grafana.local"
        ip   = "192.168.0.41"
      },
      {
        name = "prometheus.local"
        ip   = "192.168.0.41"
      }
    ]
  }
}
```

## DNS 사용 방법

### 1. 클라이언트 DNS 설정

각 클라이언트 기기에서 DNS 서버를 메인 서버 IP로 설정:

**macOS:**
```bash
# 시스템 설정 > 네트워크 > DNS 서버에 192.168.0.41 추가
# 또는 터미널에서
sudo networksetup -setdnsservers Wi-Fi 192.168.0.41 8.8.8.8
```

**Windows:**
```cmd
# 네트워크 설정 > DNS 서버에 192.168.0.41 추가
```

**Linux:**
```bash
# /etc/resolv.conf 수정
echo "nameserver 192.168.0.41" | sudo tee /etc/resolv.conf
```

### 2. 접속 확인

```bash
# DNS 해결 테스트
nslookup traefik.local 192.168.0.41

# 브라우저에서 접속
https://traefik.local:30443
https://grafana.local:30443
```

## 출력값

- `dns_namespace`: DNS 네임스페이스 이름
- `dns_server_ip`: DNS 서버 IP 주소 (메인 서버)
- `dns_port`: DNS 서버 포트 (53)
- `configured_domains`: 설정된 도메인 목록
- `deployment_name`: dnsmasq 배포 이름

## 요구사항

- Kubernetes 클러스터
- hostNetwork 권한
- 메인 서버에서 53 포트 사용 가능