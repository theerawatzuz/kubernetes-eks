1.install argocd with cli

important

- create namespace first
- don't forget to add --server-side

```
kubectl apply --server-side --force-conflicts \
-n argocd \
-f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

## check argocd ready with

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
[https://localhost:8080](https://localhost:8080)

username:
admin
password: (get password with below cli)

```
kubectl -n argocd get secret argocd-initial-admin-secret \
-o jsonpath="{.data.password}" | base64 -d && echo
```

1. Apply root-app.yaml

- change git repo as needed.
- change dns as real use needed.

```
kubectl apply -f bootstrap/argocd/root-app.yaml
```

check with 

```
kubectl get application -n argocd
```

should see 

- platform-root

1. request certificate for argocd

```
aws acm request-certificate \
  --profile theerawatsmc \
  --region ap-southeast-1 \
  --domain-name '*.thebrainsurf.site' \
  --subject-alternative-names 'thebrainsurf.site' \
  --validation-method DNS
```

Should return example :

```
{

 "CertificateArn": "arn:aws:acm:ap-southeast-1:281789399995:certificate/163daf56-7a5d-4b85-924f-15297d22ad51"

}
```

