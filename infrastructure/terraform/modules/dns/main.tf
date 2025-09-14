resource "kubernetes_namespace" "dns" {
  metadata {
    name = var.dns.namespace
    labels = {
      name = var.dns.namespace
    }
  }
}

resource "kubernetes_config_map" "dnsmasq_config" {
  metadata {
    name      = "dnsmasq-config"
    namespace = kubernetes_namespace.dns.metadata[0].name
  }

  data = {
    "dnsmasq.conf" = templatefile("${path.module}/dnsmasq.conf.tpl", {
      domains   = var.dns.domains
      server_ip = var.ssh.host
    })
  }
}

resource "kubernetes_deployment" "dnsmasq" {
  metadata {
    name      = "dnsmasq"
    namespace = kubernetes_namespace.dns.metadata[0].name
    labels = {
      app = "dnsmasq"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "dnsmasq"
      }
    }

    template {
      metadata {
        labels = {
          app = "dnsmasq"
        }
      }

      spec {
        host_network = true
        dns_policy   = "ClusterFirstWithHostNet"

        container {
          image = "jpillora/dnsmasq"
          name  = "dnsmasq"

          args = [
            "--keep-in-foreground",
            "--log-queries",
            "--conf-file=/etc/dnsmasq.conf"
          ]

          port {
            container_port = 53
            protocol       = "UDP"
          }

          port {
            container_port = 53
            protocol       = "TCP"
          }

          volume_mount {
            name       = "dnsmasq-config"
            mount_path = "/etc/dnsmasq.conf"
            sub_path   = "dnsmasq.conf"
          }

          security_context {
            capabilities {
              add = ["NET_ADMIN"]
            }
          }
        }

        volume {
          name = "dnsmasq-config"
          config_map {
            name = kubernetes_config_map.dnsmasq_config.metadata[0].name
          }
        }

        node_selector = {
          "kubernetes.io/hostname" = var.dns.target_node
        }
      }
    }
  }

  depends_on = [kubernetes_config_map.dnsmasq_config]
}
