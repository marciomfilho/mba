resource "kubernetes_namespace" "nginx" {
  metadata {
    name = "nginx"
    labels = { name = "nginx" }
  }
}

resource "kubernetes_deployment" "nginx" {
  metadata {
    name      = "nginx"
    namespace = kubernetes_namespace.nginx.metadata[0].name
  }
  spec {
    replicas = 3
    selector {
      match_labels = { app = "nginx" }
    }
    strategy {
      type = "RollingUpdate"
      rolling_update {
        max_surge       = "100%"
        max_unavailable = "25%"
      }
    }
    template {
      metadata { labels = { app = "nginx" } }
      spec {
        container {
          name  = "nginx"
          image = "nginx:latest"
          command = ["/bin/bash"]
          args = [
            "-c",
            "echo '<h1>This is the new Kubernetes default page!</h1>' > /usr/share/nginx/html/index.html && exec nginx -g 'daemon off;'"
          ]
          ports { container_port = 80 }
          resources {
            limits { cpu = "100m", memory = "256Mi" }
            requests { cpu = "50m", memory = "128Mi" }
          }
        }
        restart_policy = "Always"
      }
    }
  }
}

resource "kubernetes_service" "nginx" {
  metadata {
    name      = "nginx"
    namespace = kubernetes_namespace.nginx.metadata[0].name
  }
  spec {
    selector = { app = "nginx" }
    port {
      port        = 80
      target_port = 80
      protocol    = "TCP"
    }
    type = "LoadBalancer"
  }
}

output "nginx_lb_hostname" {
  value = kubernetes_service.nginx.status[0].load_balancer[0].ingress[0].hostname
  description = "URL de acesso do nginx pelo load balancer"
}
