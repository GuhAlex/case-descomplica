resource "helm_release" "ingress_nginx" {
  name             = "ingress-nginx"
  namespace        = "ingress-nginx"
  create_namespace = "true"
  chart            = "ingress-nginx"
  repository       = "https://kubernetes.github.io/ingress-nginx"

  values = [
    "${file("helm-values/ingress-nginx.yaml")}"
  ]
}

resource "helm_release" "prometheus_community" {
  name             = "kube-prometheus-stack"
  namespace        = "monitoring"
  create_namespace = "true"
  chart            = "kube-prometheus-stack"
  repository       = "https://prometheus-community.github.io/helm-charts"

  values = [
    "${file("helm-values/prometheus-community.yaml")}"
  ]
}

resource "helm_release" "kube_state_metrics" {
  name             = "kube-state-metrics"
  create_namespace = "true"
  namespace        = "kube-state-metrics"
  chart            = "kube-state-metrics"
  repository       = "https://prometheus-community.github.io/helm-charts"

}

resource "helm_release" "argocd" {
  name             = "argocd"
  namespace        = "argocd"
  create_namespace = "true"
  chart            = "argo-cd"
  repository       = "https://argoproj.github.io/argo-helm"

  values = [
    "${file("helm-values/argocd.yaml")}"
  ]
}

resource "helm_release" "argocd_image_updater" {
  name             = "argocd-image-updater"
  namespace        = "argocd"
  chart            = "argocd-image-updater"
  repository       = "https://argoproj.github.io/argo-helm"

  values = [
    "${file("helm-values/argocd-image-updater.yaml")}"
  ]
}

resource "helm_release" "chartmuseum" {
  name             = "chartmuseum"
  namespace        = "chartmuseum"
  create_namespace = "true"
  chart            = "chartmuseum"
  repository       = "https://chartmuseum.github.io/charts"

  values = [
    "${file("helm-values/chartmuseum.yaml")}"
  ]
}

resource "kubernetes_manifest" "ecr_sa" {

  manifest = yamldecode(file("manifests/ecr-sa.yaml"))
}

resource "kubernetes_manifest" "ecr_role" {

  manifest = yamldecode(file("manifests/ecr-role.yaml"))
}

resource "kubernetes_manifest" "ecr_role_binding" {

  manifest = yamldecode(file("manifests/ecr-role-binding.yaml"))
}

resource "kubernetes_manifest" "ecr_cronjob" {

  manifest = yamldecode(file("manifests/ecr-cronjob.yaml"))
}

resource "kubernetes_manifest" "argocd_app_goapp" {

  manifest = yamldecode(file("manifests/argocd-apps.yaml"))
}

############ SECRETS
resource "kubernetes_secret" "chartmuseum_repository" {
  metadata {
    name = "chartmuseum"
    namespace = "argocd"

    labels = {
      "argocd.argoproj.io/secret-type" = "repository"
    }
  }

  data = {
    name = "chartmuseum"
    url =  "http://chartmuseum.chartmuseum.svc.cluster.local:8080"
    type =  "helm"
  }
}

resource "kubernetes_secret" "aws_ecr_creds" {
  metadata {
    name = "aws-ecr-creds"
    namespace = "argocd"
  }

  data = {
    creds = "will_be_set_by_the_job"
  }
  lifecycle {
    ignore_changes = [
      data,
    ]
  }
