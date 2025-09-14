# dnsmasq 설정 파일
port=53
domain-needed
bogus-priv
no-resolv
no-poll
# 기본 DNS 포워딩 설정
server=1.214.68.2
server=61.41.153.2
local=/local/
domain=local
expand-hosts
log-queries

# 로컬 도메인 설정
%{ for domain in domains ~}
address=/${domain.name}/${domain.ip}
%{ endfor ~}

# 캐시 설정
cache-size=1000
neg-ttl=60

# 인터페이스 설정
listen-address=127.0.0.1
listen-address=${server_ip}
bind-interfaces

# 로그 출력 설정
log-queries
log-facility=/dev/stdout  # 로그를 stdout으로 출력