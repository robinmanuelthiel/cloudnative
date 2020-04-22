```bash
cat <<EOF | kubectl apply -f -
kind: ClusterRole
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: aadtest-read-nodes
rules:
- apiGroups: [""]
  resources: ["nodes"]
  verbs: ["*"]
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
EOF
```
