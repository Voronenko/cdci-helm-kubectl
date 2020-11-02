## Raw kubectl

```yaml
deploy:
  stage: deploy
  image: voronenko/cdci-helm-kubectl
  script:
    - kubectl config set-cluster k8s --server="${SERVER}"
    - kubectl config set clusters.k8s.certificate-authority-data ${CERTIFICATE_AUTHORITY_DATA}
    - kubectl config set-credentials gitlab --token="${USER_TOKEN}"
    - kubectl config set-context default --cluster=k8s --user=gitlab
    - kubectl config use-context default
    - sed -i "s/<VERSION>/${CI_COMMIT_SHORT_SHA}/g" deployment.yaml
    - kubectl apply -f deployment.yaml
```


## Helm3

```yaml
deploy:
  stage: deploy
  image: voronenko/cdci-helm-kubectl
  script:
    - kubectl config set-cluster k8s --server="${SERVER}"
    - kubectl config set clusters.k8s.certificate-authority-data ${CERTIFICATE_AUTHORITY_DATA}
    - kubectl config set-credentials gitlab --token="${USER_TOKEN}"
    - kubectl config set-context default --cluster=k8s --user=gitlab
    - kubectl config use-context default
    - helm upgrade your-helm-deployment-name ./your-helm-deployment-path --install --set image.tag=${CI_COMMIT_SHORT_SHA}
```
