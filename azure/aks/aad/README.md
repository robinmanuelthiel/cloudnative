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
  name: aadtest-read-nodes
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
