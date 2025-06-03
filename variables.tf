/**
 * Copyright (C) 2020 Expedia, Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 */

# Global
variable "aws_region" {
  description = "AWS region for deploying Drone Fly."
  default     = "us-east-1"
  type        = string
}

variable "k8s_image_pull_policy" {
  description = "Policy for the Kubernetes orchestrator to pull images."
  type        = string
  default     = "IfNotPresent"
}

variable "docker_registry_secret" {
  description = "Docker Registry authentication K8s secret name."
  type        = string
}

variable "k8s_namespace" {
  description = "Namespace to deploy all Kubernetes resources to."
  type        = string
  default     = "dronefly"
}

variable "k8s_dronefly_port" {
  description = "Internal port that Drone Fly runs on."
  type        = number
  default     = 8008
}

variable "k8s_dronefly_memory" {
  description = "Total memory to allocate to the Drone Fly pod."
  default     = "2Gi"
  type        = string
}

variable "k8s_dronefly_cpu" {
  description = "Total CPU to allocate to the Drone Fly pod."
  default     = "500m"
  type        = string
}

variable "prometheus_enabled" {
  description = "Enable to pull metrics using Prometheus - true or false."
  default     = false
  type        = bool
}

# Drone-fly
variable "instance_name" {
  description = "Drone Fly instance name to identify resources in multi-instance deployments. It will also be used to assign Kafka consumer group id. eg. name of the listener which will be deployed with Drone Fly."
  type        = string
}

variable "dronefly_image" {
  description = "Drone Fly docker image."
  type        = string
  default     = "expediagroup/drone-fly-app"
}

variable "dronefly_image_version" {
  description = "Version of Drone Fly docker image."
  type        = string
  default     = "0.0.1"
}

variable "dronefly_k8s_role_iam" {
  description = "K8S IAM role with required permissions for listener to work."
  type        = string
  default     = ""
}

variable "additional_environment_variables" {
  description = "Additional environment variables to be set in the Kubernetes container."
  type        = map(any)
  default     = {}
}

variable "apiary_bootstrap_servers" {
  description = "Kafka bootstrap servers that receive Hive metastore events."
  type        = string
}

variable "apiary_kafka_topic_name" {
  description = "Kafka topic name that receive Hive metastore events."
  type        = string
}

variable "apiary_listener_list" {
  description = "Comma separated list of Hive metastore listeners to load from classpath. eg. com.expedia.HMSListener1,com.expedia.HMSListener2."
  type        = string
  default     = ""
}

variable "service_account_name" {
  description = "Service account used by the deployment to access aws services"
  type        = string
  default     = ""
}

variable "datadog_metrics_enabled" {
  description = "Datadog namespace to use as prefix when deploying metrics."
  type        = bool
  default     = false
}

variable "datadog_namespace" {
  description = "Datadog namespace to use as prefix when deploying metrics."
  type        = string
  default     = "dronefly"
}

variable "datadog_metric_filters" {
  description = "Datadog metrics key used to filter metrics sent to Datadog."
  type        = list(string)
  default     = []
}

variable "datadog_kafka_group_id" {
  description = "Datadog Kafka group id to get consumer metrics."
  type        = string
  default     = "dronefly-consumer-group"
}

variable "datadog_kafka_client_api_version" {
  description = "Datadog kafka client api version."
  type        = string
  default     = "2.5.0"
}

variable "datadog_kafka_bootstrap_servers" {
  description = "Datadog kafka boostrap servers."
  type        = string
  default     = "b-1.msk-cluster-1.abcde.c2.kafka.us-east-1.amazonaws.com:9092,b-2.msk-cluster-1.abcde.c2.kafka.us-east-1.amazonaws.com:9092"
}