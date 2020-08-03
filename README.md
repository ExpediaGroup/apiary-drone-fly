# eg-tf-mod-drone-fly
Terraform module for spinning up a Kubernetes deployment for [Drone Fly](https://github.com/ExpediaGroup/drone-fly).

## Providers

| Name | Version |
|------|---------|
| kubernetes | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| additional\_environment\_variables | Additional environment variables to be set in the Kubernetes container. | `map(any)` | `{}` | no |
| apiary\_bootstrap\_servers | Kafka bootstrap servers that receive Hive metastore events. | `string` | n/a | yes |
| apiary\_kafka\_topic\_name | Kafka topic name that receive Hive metastore events. | `string` | n/a | yes |
| apiary\_listener\_list | Comma separated list of Hive metastore listeners to load from classpath. eg. com.expedia.HMSListener1,com.expedia.HMSListener2. | `string` | `""` | no |
| aws\_region | AWS region for deploying Drone Fly. | `string` | `"us-east-1"` | no |
| docker\_registry\_secret | Docker Registry authentication K8s secret name. | `string` | n/a | yes |
| dronefly\_image | Drone Fly docker image. | `string` | `"expediagroup/drone-fly-app"` | no |
| dronefly\_image\_version | Version of Drone Fly docker image. | `string` | `"latest"` | no |
| dronefly\_k8s\_role\_iam | K8S IAM role with required permissions for listener to work. | `string` | `""` | no |
| instance\_name | Drone Fly instance name to identify resources in multi-instance deployments. It will also be used to assign Kafka consumer group id. eg. name of the listener which will be deployed with Drone Fly. | `string` | n/a | yes |
| k8s\_dronefly\_cpu | Total CPU to allocate to the Drone Fly pod. | `string` | `"500m"` | no |
| k8s\_dronefly\_memory | Total memory to allocate to the Drone Fly pod. | `string` | `"2Gi"` | no |
| k8s\_dronefly\_port | Internal port that Drone Fly runs on. | `number` | `8008` | no |
| k8s\_image\_pull\_policy | Policy for the Kubernetes orchestrator to pull images. | `string` | `"IfNotPresent"` | no |
| k8s\_namespace | Namespace to deploy all Kubernetes resources to. | `string` | `"dronefly"` | no |
| prometheus\_enabled | Enable to pull metrics using Prometheus - true or false. | `bool` | `false` | no |

## Usage

Example module invocation:

```
locals {
  additional_environment_variables = {
      TEST_1 = "VAL_1"
  }
}

module "drone-fly" {
  source                              = "git::https://github.com/ExpediaGroup/apiary-drone-fly.git"
  instance_name                       = "hms-listener-1"
  aws_region                          = "us-east-1"
  dronefly_image                      = "path/to/drone-fly-image-built-on-top-of-base-image"
  dronefly_image_version              = "1.0.0"
  dronefly_k8s_role_iam               = "arn:aws:iam:us-west-2:1234567:drone-fly-k8s-role"
  docker_registry_secret              = "docker-registry-secret"
  k8s_namespace                       = "drone-fly"
  apiary_bootstrap_servers            = "localhost:9092"
  apiary_kafka_topic_name             = "apiary-metastore-events"
  apiary_listener_list                = "com.expedia.HMSListener1"
  additional_environment_variables    = local.additional_environment_variables
  prometheus_enabled                  = true
}

```

## Building Drone-Fly Docker image

To deploy Hive Metastore listeners within the Drone Fly container, we recommend building your Docker image using the Drone Fly base image. This new image will pull the listener and add it to the Drone Fly classpath inside the container, i.e. `/app/libs/`. A sample Dockerfile would look like following:

```
from expediagroup/drone-fly-app:latest

ENV APIARY_EXTENSIONS_VERSION 6.0.1

ENV AWS_REGION us-east-1
RUN cd /app/libs && \
wget -q https://search.maven.org/remotecontent?filepath=com/expediagroup/apiary/apiary-metastore-listener/${APIARY_EXTENSIONS_VERSION}/apiary-metastore-listener-${APIARY_EXTENSIONS_VERSION}-all.jar -O apiary-metastore-listener-${APIARY_EXTENSIONS_VERSION}-all.jar
```
