resource "kubernetes_namespace" "fargate" {
  metadata {
    labels = {
      app = "nginx"
    }
    name = "fargate-node"
  }
}

resource "kubernetes_deployment" "app" {
  metadata {
    name = "nginx-server"
    namespace = "fargate-node"
    labels = {
      app = "nginx"
    }
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        app = "nginx"
      }
    }

    template {
      metadata {
        labels = {
          app = "nginx"
        }
      }

      spec {
        container {
          image = "nginx"
          name = "nginx-server"

          port {
            container_port = 80
          }
        }
      }
    }
  }

  depends_on = [kubernetes_namespace.fargate]
}

resource "kubernetes_service" "app" {
  metadata {
    name = "nginx-service"
    namespace = "fargate-node"
  }
  spec {
    selector = {
      app = "nginx"
    }

    port {
      port = 80
      target_port = 80
      protocol = "TCP"
    }

    type = "NodePort"
  }

  depends_on = [kubernetes_deployment.app]
}

resource "kubernetes_ingress" "app" {
  metadata {
    name = "nginx-lb"
    namespace = "fargate-node"
    annotations = {
      "kubernetes.io/ingress.class" = "alb"
      "alb.ingress.kubernetes.io/scheme" = "internet-facing"
      "alb.ingress.kubernetes.io/target-type" = "ip"
    }
    labels = {
      "app" = "nginx"
    }
  }

  spec {
      backend {
        service_name = "nginx-service"
        service_port = 80
      }
    rule {
      http {
        path {
          path = "/"
          backend {
            service_name = "nginx-service"
            service_port = 80
          }
        }
      }
    }
  }

  depends_on = [kubernetes_service.app]
}
