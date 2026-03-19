1.install argocd with cli

important

- create namespace first
- don't forget to add --server-side

```
kubectl apply --server-side --force-conflicts \
-n argocd \
-f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

##check argocd ready with

kubectl get pods -n argocd

should be show
argocd-server
argocd-repo-server
argocd-application-controller
argocd-redis
argocd-dex-server

status
Running

1.2 port forward for quickly setup argocd
kubectl port-forward svc/argocd-server -n argocd 8080:443

open browser
https://localhost:8080

username:
admin
password: (get password with below cli)
kubectl -n argocd get secret argocd-initial-admin-secret \
-o jsonpath="{.data.password}" | base64 -d && echo
