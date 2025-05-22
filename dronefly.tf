/**
 * Copyright (C) 2020 Expedia, Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 */

resource "kubernetes_deployment_v1" "dronefly" {

  metadata {
    name      = local.instance_alias
    namespace = var.k8s_namespace

    labels = {
      name = local.instance_alias
    }
  }

  spec {
    replicas = 1
    selector {
      match_labels = {
        name = local.instance_alias
      }
    }

    template {
      metadata {
        labels = {
          name = local.instance_alias
        }
        annotations = {
          "ad.datadoghq.com/${local.instance_alias}.check_names"  = var.datadog_metrics_enabled ? "[\"prometheus\"]" : null
          "ad.datadoghq.com/${local.instance_alias}.init_configs" = var.datadog_metrics_enabled ? "[{}]" : null
          "ad.datadoghq.com/${local.instance_alias}.instances"    = var.datadog_metrics_enabled ? "[{ \"prometheus_url\": \"http://%%host%%:${var.k8s_dronefly_port}/actuator/prometheus\", \"namespace\": \"${var.datadog_namespace}\", \"metrics\":[{\"${var.datadog_metric_filter}\":{\"type\":\"gauge\"}}]}]" : null
          "prometheus.io/scrape" : "${var.prometheus_enabled}"
          "prometheus.io/port" : var.k8s_dronefly_port
          "prometheus.io/path" : "/actuator/prometheus"
        }
      }

      spec {
        service_account_name = var.service_account_name
        automount_service_account_token = true
        container {
          image             = "${var.dronefly_image}:${var.dronefly_image_version}"
          name              = local.instance_alias
          image_pull_policy = var.k8s_image_pull_policy
          port {
            container_port = var.k8s_dronefly_port
          }
          env {
            name  = "INSTANCE_NAME"
            value = local.instance_alias
          }
          env {
            name  = "APIARY_BOOTSTRAP_SERVERS"
            value = var.apiary_bootstrap_servers
          }
          env {
            name  = "APIARY_KAFKA_TOPIC_NAME"
            value = var.apiary_kafka_topic_name
          }
          env {
            name  = "APIARY_LISTENER_LIST"
            value = var.apiary_listener_list
          }
          env {
            name  = "LOG4J_FORMAT_MSG_NO_LOOKUPS"
            value = "true"
          }

          dynamic "env" {
            for_each = var.additional_environment_variables

            content {
              name  = env.key
              value = env.value
            }
          }

          liveness_probe {
            http_get {
              path = "/actuator/health/liveness"
              port = var.k8s_dronefly_port
            }
            failure_threshold     = 1
            initial_delay_seconds = 60
            period_seconds        = 10
          }
          resources {
            limits = {
              cpu    = var.k8s_dronefly_cpu
              memory = var.k8s_dronefly_memory
            }
            requests = {
              cpu    = var.k8s_dronefly_cpu
              memory = var.k8s_dronefly_memory
            }
          }
        }
        image_pull_secrets {
          name = var.docker_registry_secret
        }
      }
    }
  }
}
