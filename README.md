# k8s-project


This is the culmination of a series of Kubernetes labs. Using Minikube, I set up an array of pods,
networked them together using Services and Gateways, and will eventually handle storage and namespaces.


Documentation outline:


Set up the SynergyChat app on Kubernetes

    Applied multiple YAML manifests to create:
        web frontend resources (Deployment, Service, ConfigMap, HTTPRoute).
        api backend resources (Deployment, Service, ConfigMap, PVC, maybe HTTPRoute).
        crawler worker resources (Deployment, Service, ConfigMap).
    Verified that pods, services, and routes were running in the default namespace using kubectl get commands.

Worked with ConfigMaps and environment/config

    Created ConfigMaps for each component (web, api, crawler) to store configuration values.
    Wired those configs into pods via environment variables or envFrom sections in the Deployment specs.
    Re‑applied manifests and checked that updated configuration was reflected in new pods.

Exposed services and routing

    Defined Service objects to expose:
        Frontend web traffic.
        Backend API.
        Internal communication for the crawler.
    Used Gateway/HTTPRoute resources to route external HTTP traffic into the cluster (e.g., browser → web → api).

Handled persistent data (for the API)

    Created a PersistentVolumeClaim for the API to store data.
    Attached the PVC to the API Deployment using volumes and volumeMounts.
    Ensured the API pod could restart without losing its persistent data.

Organized components with namespaces (current step)

    Created a new namespace:

    kubectl create ns crawler

Updated crawler manifests (crawler-deployment.yaml, crawler-service.yaml, crawler-configmap.yaml) to include:

metadata:
  name: ...
  namespace: crawler

Applied those manifests so the crawler resources are recreated in the crawler namespace.
Verified crawler pods/services/configmaps in that namespace using:

kubectl -n crawler get pods
kubectl -n crawler get svc
kubectl -n crawler get configmaps

Deleted the old crawler resources from the default namespace.
Ran kubectl proxy and then the CLI tests to confirm everything is wired correctly.
