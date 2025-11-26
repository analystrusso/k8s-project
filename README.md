# k8s-project

This repository contains the culmination of a series of Kubernetes labs. Using Minikube, I deployed the SynergyChat application as a small, multi-service system. The work covers core Kubernetes concepts: pods, deployments, services, config, routing, autoscaling, storage, and namespaces.

## Overview

The SynergyChat app is composed of three main components:

- **Web** – frontend UI
- **API** – backend service with persistent data
- **Crawler** – background worker that talks to the API

These components are deployed to a local Kubernetes cluster (Minikube) and wired together using standard Kubernetes resources.

## What I Implemented

### Cluster Setup & Core Resources

- Ran a local **Minikube** cluster for development.
- Applied multiple YAML manifests to create:
  - **Deployments** for web, api, and crawler pods.
  - **Services** for stable networking between components.
  - **ConfigMaps** for configuration.
  - **HTTPRoute / Gateway** resources for HTTP ingress.
- Used `kubectl get`, `describe`, and `logs` to verify and debug:
  - Pods
  - ReplicaSets
  - Deployments
  - Services
  - Routes / Gateways

### Config & Environment Management

- Created **ConfigMaps** for each component:
  - `web-config`
  - `api-config`
  - `crawler-config`
- Injected configuration via:
  - `env` and `envFrom` on `Deployment` specs.
- Practiced updating config by:
  - Editing ConfigMaps.
  - Re-applying manifests.
  - Verifying new pods picked up the updated configuration.

### Service Discovery & Routing

- Defined **ClusterIP Services** for internal communication:
  - Frontend → API
  - Crawler → API
- Exposed the web frontend via:
  - **Service** (and optionally `NodePort` / `LoadBalancer` in Minikube).
  - **Gateway / HTTPRoute** to route external HTTP traffic into the cluster.
- Verified end-to-end flow:
  - Browser → Gateway/HTTPRoute → Web → API → Crawler/API.

### Scaling & Reliability (Deployments, Probes, Autoscaling)

- Used **Deployments** to manage replica sets and rolling updates.
- Configured **liveness** and **readiness** probes (where applicable) so:
  - Kubernetes can restart unhealthy pods.
  - Traffic only routes to ready pods.
- Practiced **scaling**:
  - Manually changed `spec.replicas` in Deployment manifests.
  - Used `kubectl scale` to add/remove replicas.
- Explored **resource requests & limits**:
  - Set CPU/memory requests to influence pod scheduling.
  - Set CPU/memory limits to protect nodes from runaway containers.

### Persistent Storage (API)

- Created a **PersistentVolumeClaim (PVC)** for the API to store data.
- Mounted the PVC into the API Deployment via:
  - `volumes`
  - `volumeMounts`
- Verified that:
  - API pods could restart without losing data.
  - Storage was decoupled from individual pod lifecycles.

### Namespaces & Organization

- Created a dedicated **namespace** for the crawler:

  bash
  kubectl create ns crawler

Updated crawler manifests (crawler-deployment.yaml, crawler-service.yaml, crawler-configmap.yaml) to include:

metadata:
  name: ...
  namespace: crawler

Applied manifests into the crawler namespace and verified resources:

	kubectl -n crawler get pods
	kubectl -n crawler get svc
	kubectl -n crawler get configmaps

Cleaned up legacy crawler resources from the default namespace.

Confirmed the system still worked end-to-end by:
        Running kubectl proxy
        Running the provided CLI tests against the cluster.

Observability & Debugging

Used kubectl extensively to inspect and debug:
        kubectl get / describe for deployments, pods, services, and routes.
        kubectl logs for application logs.
        kubectl port-forward / kubectl proxy for local access and testing.

How to Run This Project
Prerequisites

    Minikube
    kubectl configured to talk to your Minikube cluster
    Docker (for building images, if needed)

Setup

    Start Minikube:

    minikube start

Apply the manifests (exact file paths may differ):

kubectl apply -f k8s/web/
kubectl apply -f k8s/api/
kubectl apply -f k8s/crawler/
kubectl apply -f k8s/gateway/

Verify resources:

kubectl get pods
kubectl get svc
kubectl get deployments

    Access the app (examples):
        Via kubectl port-forward or minikube service for the web Service.
        Or via Gateway/HTTPRoute if configured.

Lessons Learned

    How to model a small, real-world app using Deployments, Services, ConfigMaps, PVCs, and Namespaces.
    How requests and limits affect scheduling and autoscaling behavior.
    How to expose applications safely using Gateways/HTTPRoutes.
    How to separate concerns by placing components into different namespaces.
    How to debug and iterate on manifests using core kubectl commands.

