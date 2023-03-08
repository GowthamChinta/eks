resource "local_file" "karpenter_values" {
  content = yamlencode({
    "affinity" = {
      "nodeAffinity" = {
        "requiredDuringSchedulingIgnoredDuringExecution" = {
          "nodeSelectorTerms" = [{
            "matchExpressions" = [
              {
                "key"      = var.node_key
                "operator" = "In"
                "values" = [
                  var.node_value
                ]
              },
            ]
          }]
        }
      }
    }
    "tolerations" = [
      {
        "key"      = var.node_key
        "operator" = "Equal"
        "value"    = var.node_value
        "effect"   = "NoSchedule"
      }
    ]
    "settings" = {
      "aws" = {
        "clusterName"            = var.cluster_name
        "clusterEndpoint"        = var.cluster_endpoint
        "defaultInstanceProfile" = "KarpenterNodeInstanceProfile-${var.cluster_name}"
        "interruptionQueueName"  = var.cluster_name
      }
    }
    "serviceAccount" = {
      "annotations" = {
        "eks.amazonaws.com/role-arn" = "arn:aws:iam::${var.account}:role/${var.cluster_name}-karpenter"
      }
    }
  })
  filename = "${path.module}/../../../base-applications/karpenter-values.yaml"
}

resource "local_file" "batchservice_provisioner" {
  content = yamlencode({
    "apiVersion" = "karpenter.sh/v1alpha5"
    "kind"       = "Provisioner"
    "metadata" = {
      "name" = "batchservices"
    }
    "spec" = {
      "requirements" = [{
        "key"      = "karpenter.sh/capacity-type"
        "operator" = "In"
        "values" = [
          var.production ? "on-demand" : "spot"
        ]},{
        "key"      = "node.kubernetes.io/instance-type"
        "operator" = "In"
        "values" = [
          var.instance_size
        ]
      }]
      "limits" = {
        "resources" = {
          "cpu" = 1000
        }
      }
      "labels" = {
        "eks.amazonaws.com/nodegroup" = "batchservices"
      }
      "taints" = [{
        "key"   = "eks.amazonaws.com/nodegroup"
        "value" = "batchservices"
        "effect" : "NoSchedule"
      }]
      "providerRef" = {
        "name" = "batchservices"
      }
      "ttlSecondsAfterEmpty" = 30
    }
  })
  filename = "${path.module}/../../../base-applications/karpenter/batchservices-provisioner.yaml"
}

resource "local_file" "batchservice_awstemplate" {
  content = yamlencode({
    "apiVersion" = "karpenter.k8s.aws/v1alpha1"
    "kind"       = "AWSNodeTemplate"
    "metadata" = {
      "name" = "batchservices"
    }
    "spec" = {
      "subnetSelector" = {
        "aws-ids" = var.subnet_id
      }
      "securityGroupSelector" = {
        "aws-ids" = var.security_group
      }
    }
  })
  filename = "${path.module}/../../../base-applications/karpenter/batchservices-awstemplate.yaml"
}

resource "local_file" "aiml_provisioner" {
  content = yamlencode({
    "apiVersion" = "karpenter.sh/v1alpha5"
    "kind"       = "Provisioner"
    "metadata" = {
      "name" = "aiml"
    }
    "spec" = {
      "requirements" = [{
        "key"      = "karpenter.sh/capacity-type"
        "operator" = "In"
        "values" = [
          var.production ? "on-demand" : "spot"
        ]},{
        "key"      = "node.kubernetes.io/instance-type"
        "operator" = "In"
        "values" = [
          var.instance_size
        ]
      }]
      "limits" = {
        "resources" = {
          "cpu" = 1000
        }
      }
      "labels" = {
        "eks.amazonaws.com/nodegroup" = "aiml"
      }
      "taints" = [{
        "key"   = "eks.amazonaws.com/nodegroup"
        "value" = "aiml"
        "effect" : "NoSchedule"
      }]
      "providerRef" = {
        "name" = "aiml"
      }
      "ttlSecondsAfterEmpty" = 30
    }
  })
  filename = "${path.module}/../../../base-applications/karpenter/aiml-provisioner.yaml"
}

resource "local_file" "aiml_awstemplate" {
  content = yamlencode({
    "apiVersion" = "karpenter.k8s.aws/v1alpha1"
    "kind"       = "AWSNodeTemplate"
    "metadata" = {
      "name" = "aiml"
    }
    "spec" = {
      "subnetSelector" = {
        "aws-ids" = var.subnet_id
      }
      "securityGroupSelector" = {
        "aws-ids" = var.security_group
      }
    }
  })
  filename = "${path.module}/../../../base-applications/karpenter/aiml-awstemplate.yaml"
}

resource "local_file" "dw_provisioner" {
  content = yamlencode({
    "apiVersion" = "karpenter.sh/v1alpha5"
    "kind"       = "Provisioner"
    "metadata" = {
      "name" = "dw"
    }
    "spec" = {
      "requirements" = [{
        "key"      = "karpenter.sh/capacity-type"
        "operator" = "In"
        "values" = [
          var.production ? "on-demand" : "spot"
        ]},{
        "key"      = "node.kubernetes.io/instance-type"
        "operator" = "In"
        "values" = [
          var.instance_size
        ]
      }]
      "limits" = {
        "resources" = {
          "cpu" = 1000
        }
      }
      "labels" = {
        "eks.amazonaws.com/nodegroup" = "dw"
      }
      "taints" = [{
        "key"   = "eks.amazonaws.com/nodegroup"
        "value" = "dw"
        "effect" : "NoSchedule"
      }]
      "providerRef" = {
        "name" = "dw"
      }
      "ttlSecondsAfterEmpty" = 30
    }
  })
  filename = "${path.module}/../../../base-applications/karpenter/dw-provisioner.yaml"
}

resource "local_file" "dw_awstemplate" {
  content = yamlencode({
    "apiVersion" = "karpenter.k8s.aws/v1alpha1"
    "kind"       = "AWSNodeTemplate"
    "metadata" = {
      "name" = "dw"
    }
    "spec" = {
      "subnetSelector" = {
        "aws-ids" = var.subnet_id
      }
      "securityGroupSelector" = {
        "aws-ids" = var.security_group
      }
    }
  })
  filename = "${path.module}/../../../base-applications/karpenter/dw-awstemplate.yaml"
}

resource "local_file" "streaming_provisioner" {
  content = yamlencode({
    "apiVersion" = "karpenter.sh/v1alpha5"
    "kind"       = "Provisioner"
    "metadata" = {
      "name" = "streaming"
    }
    "spec" = {
      "requirements" = [{
        "key"      = "karpenter.sh/capacity-type"
        "operator" = "In"
        "values" = [
          var.production ? "on-demand" : "spot"
        ]},{
        "key"      = "node.kubernetes.io/instance-type"
        "operator" = "In"
        "values" = [
          var.instance_size
        ]
      }]
      "limits" = {
        "resources" = {
          "cpu" = 1000
        }
      }
      "labels" = {
        "eks.amazonaws.com/nodegroup" = "streaming"
      }
      "taints" = [{
        "key"   = "eks.amazonaws.com/nodegroup"
        "value" = "streaming"
        "effect" : "NoSchedule"
      }]
      "providerRef" = {
        "name" = "streaming"
      }
      "ttlSecondsAfterEmpty" = 30
    }
  })
  filename = "${path.module}/../../../base-applications/karpenter/streaming-provisioner.yaml"
}

resource "local_file" "streaming_awstemplate" {
  content = yamlencode({
    "apiVersion" = "karpenter.k8s.aws/v1alpha1"
    "kind"       = "AWSNodeTemplate"
    "metadata" = {
      "name" = "streaming"
    }
    "spec" = {
      "subnetSelector" = {
        "aws-ids" = var.subnet_id
      }
      "securityGroupSelector" = {
        "aws-ids" = var.security_group
      }
    }
  })
  filename = "${path.module}/../../../base-applications/karpenter/streaming-awstemplate.yaml"
}

resource "local_file" "system_provisioner" {
  content = yamlencode({
    "apiVersion" = "karpenter.sh/v1alpha5"
    "kind"       = "Provisioner"
    "metadata" = {
      "name" = "system"
    }
    "spec" = {
      "requirements" = [{
       "key"      = "karpenter.sh/capacity-type"
        "operator" = "In"
        "values" = [
          var.production ? "on-demand" : "spot"
        ]},{
        "key"      = "node.kubernetes.io/instance-type"
        "operator" = "In"
        "values" = [
          var.instance_size
        ]}]
      "limits" = {
        "resources" = {
          "cpu" = 1000
        }
      }
      "labels" = {
        "eks.amazonaws.com/nodegroup" = "default"
      }
      "providerRef" = {
        "name" = "default"
      }
      "ttlSecondsAfterEmpty" = 30
    }
  })
  filename = "${path.module}/../../../base-applications/karpenter/system-provisioner.yaml"
}

resource "local_file" "system_awstemplate" {
  content = yamlencode({
    "apiVersion" = "karpenter.k8s.aws/v1alpha1"
    "kind"       = "AWSNodeTemplate"
    "metadata" = {
      "name" = "system"
    }
    "spec" = {
      "subnetSelector" = {
        "aws-ids" = var.subnet_id
      }
      "securityGroupSelector" = {
        "aws-ids" = var.security_group
      }
    }
  })
  filename = "${path.module}/../../../base-applications/karpenter/system-awstemplate.yaml"
}
resource "local_file" "deafult_provisioner" {
  content = yamlencode({
    "apiVersion" = "karpenter.sh/v1alpha5"
    "kind"       = "Provisioner"
    "metadata" = {
      "name" = "default"
    }
    "spec" = {
      "requirements" = [{
       "key"      = "karpenter.sh/capacity-type"
        "operator" = "In"
        "values" = [
          var.production ? "on-demand" : "spot"
        ]},{
        "key"      = "node.kubernetes.io/instance-type"
        "operator" = "In"
        "values" = [
          var.instance_size
        ]}]
      "limits" = {
        "resources" = {
          "cpu" = 1000
        }
      }
      "labels" = {
        "eks.amazonaws.com/nodegroup" = "default"
      }
      "providerRef" = {
        "name" = "default"
      }
      "ttlSecondsAfterEmpty" = 30
    }
  })
  filename = "${path.module}/../../../base-applications/karpenter/default-provisioner.yaml"
}

resource "local_file" "deafult_awstemplate" {
  content = yamlencode({
    "apiVersion" = "karpenter.k8s.aws/v1alpha1"
    "kind"       = "AWSNodeTemplate"
    "metadata" = {
      "name" = "default"
    }
    "spec" = {
      "subnetSelector" = {
        "aws-ids" = var.subnet_id
      }
      "securityGroupSelector" = {
        "aws-ids" = var.security_group
      }
    }
  })
  filename = "${path.module}/../../../base-applications/karpenter/default-awstemplate.yaml"
}
