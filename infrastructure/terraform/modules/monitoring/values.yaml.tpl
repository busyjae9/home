prometheus:
  prometheusSpec:
    retention: ${prometheus_retention}
    storageSpec:
      volumeClaimTemplate:
        spec:
          storageClassName: local-path
          accessModes: ["ReadWriteOnce"]
          resources:
            requests:
              storage: ${prometheus_storage_size}
  ingress:
    enabled: ${prometheus_ingress_enabled}
    ingressClassName: ${prometheus_ingress_class}
    hosts:
      - ${prometheus_ingress_host}
    paths:
      - /

grafana:
  adminPassword: ${grafana_admin_password}
  persistence:
    enabled: true
    storageClassName: local-path
    size: 10Gi
  ingress:
    enabled: ${grafana_ingress_enabled}
    ingressClassName: ${grafana_ingress_class}
    hosts:
      - ${grafana_ingress_host}
    %{ if grafana_ingress_tls_enabled }
    tls:
      - secretName: ${grafana_ingress_secret_name}
        hosts:
          - ${grafana_ingress_host}
    %{ endif }
  grafana.ini:
    server:
      root_url: "https://${grafana_ingress_host}"
    security:
      allow_embedding: true
    auth.anonymous:
      enabled: false

alertmanager:
  alertmanagerSpec:
    storage:
      volumeClaimTemplate:
        spec:
          storageClassName: local-path
          accessModes: ["ReadWriteOnce"]
          resources:
            requests:
              storage: 5Gi
  ingress:
    enabled: ${alertmanager_ingress_enabled}
    ingressClassName: ${alertmanager_ingress_class}
    hosts:
      - ${alertmanager_ingress_host}
    paths:
      - /

kubeStateMetrics:
  enabled: true

nodeExporter:
  enabled: true

prometheusOperator:
  enabled: true
  admissionWebhooks:
    failurePolicy: Fail
    enabled: true