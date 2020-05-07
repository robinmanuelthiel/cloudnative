```bash
cat <<EOF | kubectl apply -f -
kind: ClusterRole
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: aadtest-read-nodes
rules:
- apiGroups: [""]
  resources: ["nodes"]
  verbs: ["get","list","watch"]
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: aadtest-read-nodes-binding
subjects:
- kind: ServiceAccount
  name: aadtest
  namespace: default
roleRef:
  kind: ClusterRole
  name: aadtest-read-nodes
  apiGroup: rbac.authorization.k8s.io
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: rothie-read-nodes-binding
subjects:
- apiGroup: rbac.authorization.k8s.io
  kind: User
  name: 4bf212a7-4318-4391-9d0d-206815fc3d9f
roleRef:
  kind: ClusterRole
  name: aadtest-read-nodes
  apiGroup: rbac.authorization.k8s.io
EOF
```


# Test Service Account Token

```bash
sa_secret_name=$(kubectl get serviceaccount api-service-account  -o json | jq -Mr '.secrets[].name')
echo "SA secret name " $sa_secret_name
 
sa_secret_value=$(kubectl get secrets  $sa_secret_name -o json | jq -Mr '.data.token' | base64 -d)
echo "SA secret  " $sa_secret_value
 
kube_url=$(kubectl get endpoints -o jsonpath='{.items[0].subsets[0].addresses[0].ip}')
echo "Kube URL " $kube_url
 
curl -k  https://$kube_url/api/v1/namespaces -H "Authorization: Bearer $sa_secret_value"

