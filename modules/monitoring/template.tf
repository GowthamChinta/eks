resource "local_file" "monitoring_values" {
  content = yamlencode({
    "alertmanager" = {
        "ingress" = {
            "enabled" = false
            "ingressClassName" = "nginx"
            "hosts" = [
                var.host_name
            ]
            "paths" = [
                "/alertmanager-system"
            ]
            "tls" = [{
                "secretName" = "getrightdata"
                "hosts" = [
                    var.host_name
                ]
            }]
        }
        "alertmanagerSpec" = {
            "affinity" = {
                "nodeAffinity" = {
                    "requiredDuringSchedulingIgnoredDuringExecution" = {
                        "nodeSelectorTerms" = [{
                            "matchExpressions" = [{
                                "key" = "eks.amazonaws.com/nodegroup"
                                "operator" =  "In"
                                "values" = [
                                    "system" 
                                ]
                            }]
                        }]
                    }
                }
            }            
            "tolerations" = [{
                "key" = "eks.amazonaws.com/nodegroup"
                "operator" = "Equal"
                "value" = "system"
                "effect" = "NoSchedule"
            }]
        }
    }    
    "grafana" = {
        "tolerations" = [{
                "key" = "eks.amazonaws.com/nodegroup"
                "operator" = "Equal"
                "value" = "system"
                "effect" = "NoSchedule"
            }]
        "affinity" = {
                "nodeAffinity" = {
                    "requiredDuringSchedulingIgnoredDuringExecution" = {
                        "nodeSelectorTerms" = [{
                            "matchExpressions" = [{
                                "key" = "eks.amazonaws.com/nodegroup"
                                "operator" =  "In"
                                "values" = [
                                    "system" 
                                ]
                            }]
                        }]
                    }
                }
            }         
        "grafana.ini" = {
            "server" = {
                "root_url": "https://${var.host_name}/grafana-system"
            }
        }
        "ingress" = {
            "enabled" = true
            "ingressClassName" = "nginx"
            "annotations" = {
                "nginx.ingress.kubernetes.io/rewrite-target" = "/$2"
            }
            "path" = "/grafana-system(/|$)(.*)"
            "hosts" = [
                var.host_name
            ]
            "tls" = [{
                "secretName" = "getrightdata"
                "hosts" = [
                    var.host_name
                ]
            }]
        }
    }
    "prometheus" = {
        "ingress" = {
            "enabled" = true
            "ingressClassName" = "nginx"
            "annotations" = {
                "nginx.ingress.kubernetes.io/rewrite-target" = "/$2"
            }
            "paths" = [
                "/prometheus-system(/|$)(.*)"
            ]
            "hosts" = [
                var.host_name
            ]
            "tls" = [{
                "secretName" = "getrightdata"
                "hosts" = [
                    var.host_name
                ]
            }]
        }
        "prometheusSpec" = {
            "additionalArgs" = [{
                "name" = "web.external-url"
                "value" = "http://${var.host_name}/prometheus-system"
            },
            {   "name" = "web.route-prefix"
                "value" = "/"
            }]
            "tolerations" = [{
                "key" = "eks.amazonaws.com/nodegroup"
                "operator" = "Equal"
                "value" = "system"
                "effect" = "NoSchedule"
            }]
            "affinity" = {
                "nodeAffinity" = {
                    "requiredDuringSchedulingIgnoredDuringExecution" = {
                        "nodeSelectorTerms" = [{
                            "matchExpressions" = [{
                                "key" = "eks.amazonaws.com/nodegroup"
                                "operator" =  "In"
                                "values" = [
                                    "system" 
                                ]
                            }]
                        }]
                    }
                }
            }
        }
    }
    "prometheusOperator" = {
        "tolerations" = [{
            "key" = "eks.amazonaws.com/nodegroup"
            "operator" = "Equal"
            "value" = "system"
            "effect" = "NoSchedule"
        }]
        "affinity" = {
            "nodeAffinity" = {
                "requiredDuringSchedulingIgnoredDuringExecution" = {
                    "nodeSelectorTerms" = [{
                        "matchExpressions" = [{
                            "key" = "eks.amazonaws.com/nodegroup"
                            "operator" =  "In"
                            "values" = [
                                "system" 
                            ]
                        }]
                    }]
                }
            }
        }
        "admissionWebhooks" = {
            "patch" = {
                "tolerations" = [{
                    "key" = "eks.amazonaws.com/nodegroup"
                    "operator" = "Equal"
                    "value" = "system"
                    "effect" = "NoSchedule"
                }]
                "affinity" = {
                    "nodeAffinity" = {
                        "requiredDuringSchedulingIgnoredDuringExecution" = {
                            "nodeSelectorTerms" = [{
                                "matchExpressions" = [{
                                    "key" = "eks.amazonaws.com/nodegroup"
                                    "operator" =  "In"
                                    "values" = [
                                        "system" 
                                    ]
                                }]
                            }]
                        }
                    }
                }
            }
        }
    }
    "kube-state-metrics" = {
        "tolerations" = [{
            "key" = "eks.amazonaws.com/nodegroup"
            "operator" = "Equal"
            "value" = "system"
            "effect" = "NoSchedule"
        }]
        "affinity" = {
            "nodeAffinity" = {
                "requiredDuringSchedulingIgnoredDuringExecution" = {
                    "nodeSelectorTerms" = [{
                        "matchExpressions" = [{
                            "key" = "eks.amazonaws.com/nodegroup"
                            "operator" =  "In"
                            "values" = [
                                "system" 
                            ]
                        }]
                    }]
                }
            }
        }
    }
  })
  filename = "${path.module}/../../../base-applications/monitoring-values.yaml"
}
