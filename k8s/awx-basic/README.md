# install minikube via dockerinstall minikube via docker

install

```
# https://minikube.sigs.k8s.io/docs/start/?arch=%2Flinux%2Fx86-64%2Fstable%2Fbinary+download
```
```
# enable ingress
$ sudo usermod -aG docker $USER && newgrp docker
$ minikube addons enable ingress
```
## get awx repoget awx repo

```
$ git clone https://github.com/ansible/awx-operator
```
```
$ # change to version
cd awx-operator
git checkout tags/2.19.
cd awx-operator/config
```
## FIX ISSUEFIX ISSUE

The issue is https://github.com/ansible/awx/issues/16335 says kube-rbac-proxy:v0.15.0 moved to Docker registry from Google

```
$ cd awx-operator/config
$ find. -type f -exec grep -l kube-rbac-proxy {} \;
#replace "gcr.io/kubebuilder/kube-rbac-proxy:v0.15.0" with "image: docker.io/kubebuilder/kube-rbac-proxy:v0.15.0" in " default/manager_auth_proxy_patch.yaml"
```
## Final basic configs

```
tree default/
default/
├── awx-ingress.yaml
├── demo.yaml
├── kustomization.yaml
├── manager_auth_proxy_patch.yaml
└── manager_config_patch.yaml
```
```
1 directory, 5 files
```
## Replace Replace default/kustomization.yamldefault/kustomization.yaml file resource file resource

put right version from git (2.19.1) github.com/ansible/awx-operator/config/default?ref=2.19.


```
$ cat default/kustomization.yaml
# Adds namespace to all resources.
namespace: awx
```
```
namePrefix: awx-operator-
```
```
resources:
#- ../crd
#- ../rbac
#- ../manager
# THIS IS CHANGE
```
- github.com/ansible/awx-operator/config/default?ref=2.19.
# THESE ARE ADDED
- demo.yaml
- awx-ingress.yaml

```
apiVersion: kustomize.config.k8s.io/v1beta
kind: Kustomization
patches:
```
- path: manager_auth_proxy_patch.yaml

```
# not sure needed
```
```
cat default/demo.yaml
---
apiVersion: awx.ansible.com/v1beta
kind: AWX
metadata:
name: awx-demo
spec:
service_type: nodeport
```
```
$ cat default/awx-ingress.yaml
apiVersion: networking.k8s.io/v
kind: Ingress
metadata:
name: awx-ingress
namespace: awx
annotations:
nginx.ingress.kubernetes.io/proxy-body-size: "100m"
spec:
ingressClassName: nginx
```
```
rules:
```
- host: awx.example.com
[http:](http:)
paths:
- path: /
pathType: Prefix
backend:
service:
name: awx-operator-awx-demo-service
port:
number: 80

# Apply changesApply changes


```
kubectl apply -k default/
namespace/awx created
customresourcedefinition.apiextensions.k8s.io/awxbackups.awx.ansible.com created
customresourcedefinition.apiextensions.k8s.io/awxmeshingresses.awx.ansible.com created
customresourcedefinition.apiextensions.k8s.io/awxrestores.awx.ansible.com created
customresourcedefinition.apiextensions.k8s.io/awxs.awx.ansible.com created
serviceaccount/awx-operator-awx-operator-controller-manager created
role.rbac.authorization.k8s.io/awx-operator-awx-operator-awx-manager-role created
role.rbac.authorization.k8s.io/awx-operator-awx-operator-leader-election-role created
clusterrole.rbac.authorization.k8s.io/awx-operator-awx-operator-metrics-reader created
clusterrole.rbac.authorization.k8s.io/awx-operator-awx-operator-proxy-role created
rolebinding.rbac.authorization.k8s.io/awx-operator-awx-operator-awx-manager-rolebinding created
rolebinding.rbac.authorization.k8s.io/awx-operator-awx-operator-leader-election-rolebinding created
clusterrolebinding.rbac.authorization.k8s.io/awx-operator-awx-operator-proxy-rolebinding created
configmap/awx-operator-awx-operator-awx-manager-config created
service/awx-operator-awx-operator-controller-manager-metrics-service created
deployment.apps/awx-operator-awx-operator-controller-manager created
awx.awx.ansible.com/awx-operator-awx-demo created
ingress.networking.k8s.io/awx-operator-awx-ingress created
```
# Expose ingress to Host.Expose ingress to Host.

make accessible all interface if engine is docker or podman etc. Otherwise bridge minikube listen docker bridge interface

```
minikube tunnel --bind-address='0.0.0.0'
```
# enable dns or /etc/hostsenable dns or /etc/hosts



