# Cloud Container  
## L1  
- [Artifact Repository exists](https://github.com/o-lenczyk/peex/blob/main/CloudContainer/repo.tf#L1) and images can be stored/pushed there
- [Dockerfile](CloudBuild/Dockerfile) exist (write your own or use an existing Dockerfile that is based on any parent image)
- Image is working without any errors (use docker run command)
- built image is [pushed](https://github.com/o-lenczyk/peex/blob/main/CloudContainer/repo.tf#L1) to the Artifact Repository
  
## L2  
- create a GKE cluster with two [node pools](https://github.com/o-lenczyk/peex/blob/main/CloudContainer/gke.tf#L32)
- node pools are visible via Google console, kubectl or gcloud
- node pools [can be easily resized](https://github.com/o-lenczyk/peex/blob/main/CloudContainer/gke.tf#L37)
- [upgrade strategy](https://github.com/o-lenczyk/peex/blob/main/CloudContainer/gke.tf#L40) for your cluster is created
- alerts/updates about the new GKE version are [prepared](https://github.com/o-lenczyk/peex/blob/main/CloudContainer/gke.tf#L18)
- [maintenance window](https://github.com/o-lenczyk/peex/blob/main/CloudContainer/gke.tf#L25) for the cluster is defined
- upgrade strategy is defined for every node pool in the cluster (upgrade strategy of your choice, try both of them)
- enable notifications about cluster events
- notifications for your cluster works
- system and control plane metrics (observability metrics) are enabled
- observability metrics are visible in Kubernetes Clusters -> Observability tab
- monitoring for your cluster is enabled
- [dashboard](screenshots/monitoring.png) for GKE is visible in Cloud Monitoring
- [logs](screenshots/logs.png) for GKE are visible in Logs Explorer
- metrics-based [alerts](screenshots/alert.png) for your cluster are created and work
- monitoring for Kubernetes cluster enabled (create a cluster with monitoring enabled or enable it if the cluster exists)
- configure the metrics you want to send to Cloud Monitoring
- dashboard for Kubernetes Engine is visible and shows basic metrics
- alerts based on metrics are created (alerts of your choice)
- logs for K8s are visible in Logs Explorer and can be queried


## L3
- Autoscaling a cluster
- Container instance autoscaling
- Integrate a Kubernetes Cluster with an [External Vault](gifs/k8s-hashicorp-vault.gif) 
- [Manage](gifs/helm-repo.gif) Helm charts
- [Create](Helm/hello-chart/) a sample chart
- Use Anthos Service Mesh egress gateways on the GKE clusters

## L4
Documented activities around the migration of a workload to the containerized environment that would consist of the following activities:
- Analyzing the existing infrastructure, all dependencies, and connections with external systems
- Plan the target infrastructure
- Supervise the creation of images with microservices
- Assist in testing activities including setting up the test plan for the workload in a containerized environment