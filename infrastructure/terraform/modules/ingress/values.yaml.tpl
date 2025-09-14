deployment:
  enabled: true
  replicas: 1

service:
  enabled: true
  type: NodePort
  spec:
    externalTrafficPolicy: Local

ports:
  web:
    port: 8000
    expose: true
    exposedPort: 80
    nodePort: ${node_port_http}
    protocol: TCP
  websecure:
    port: 8443
    expose: true
    exposedPort: 443
    nodePort: ${node_port_https}
    protocol: TCP
    tls:
      enabled: true
      options: ""
      certResolver: ""
      domains: []
  traefik:
    port: 9000
    expose: false
    protocol: TCP

ingressClass:
  enabled: true
  isDefaultClass: true

ingressRoute:
  dashboard:
    enabled: ${dashboard_enabled}
    annotations: {}
    labels: {}
    matchRule: Host(`${dashboard_host}`)
    entryPoints: ["websecure"]
    middlewares: []
    tls:
      secretName: ${default_cert_secret_name}

api:
  dashboard: true
  debug: false
  insecure: ${dashboard_insecure_enabled}

entryPoints:
  web:
    address: ":8000"
  websecure:
    address: ":8443"

providers:
  kubernetesCRD:
    enabled: true
    allowCrossNamespace: false
    allowExternalNameServices: false
    allowEmptyServices: false
    ingressClass: traefik
    labelSelector: ""
    namespaces: []
  kubernetesIngress:
    enabled: true
    allowExternalNameServices: false
    allowEmptyServices: false
    ingressClass: traefik
    labelSelector: ""
    namespaces: []
    ingressEndpoint:
      ip: ""
      hostname: ""
      publishedService: ""

globalArguments:
  - "--global.checknewversion"
  - "--global.sendanonymoususage"

certificatesResolvers: {}

additionalArguments: []

environment: []

envFrom: []

secretMounts: []

volumes: []

additionalVolumeMounts: []

logs:
  general:
    level: ERROR
  access:
    enabled: false