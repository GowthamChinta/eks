resource "local_file"   "kubedashboard_values"  {
    content = yamlencode({
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
        "ingress" = {
            "enabled" = true
            "annotations" = {
                "nginx.ingress.kubernetes.io/rewrite-target" = "/$2"
                "nginx.ingress.kubernetes.io/configuration-snippet" = "rewrite ^(/kube-dashboard)$ $1/ redirect;"
            }
            "className" = "nginx"
            "paths" = [
                "/kube-dashboard(/|$)(.*)"
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
        "rbac" = {
            "create" = true
            "clusterRoleMetrics" = true
            "clusterReadOnlyRole" = true
        }

    })
    filename = "${path.module}/../../../base-applications/kubedashboard-values.yaml"
}

