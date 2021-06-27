kubectl create namespace zowe
kubectl get namespaces --show-labels
kubectl config set-context --current --namespace=zowe

kubectl apply -f dropins-volume-persistentvolumeclaim.yaml

kubectl apply -f discovery-service-deployment.yaml,gateway-service-deployment.yaml,api-catalog-service-deployment.yaml
kubectl apply -f discovery-service-service.yaml,gateway-service-service.yaml,api-catalog-service-service.yaml

kubectl apply -f datasets-api-service-deployment.yaml,jobs-api-service-service.yaml
kubectl apply -f datasets-api-service-service.yaml,jobs-api-service-service.yaml

kubectl apply -f explorer-jes-pod.yaml,explorer-mvs-pod.yaml,explorer-uss-pod.yaml
kubectl apply -f explorer-jes-service.yaml,explorer-mvs-service.yaml,explorer-uss-service.yaml

kubectl apply -f zlux-editor-plugin-pod.yaml,zlux-tn3270-plugin-pod.yaml,zlux-vt-plugin-pod.yaml,zss-auth-plugin-pod.yaml

kubectl apply -f zlux-app-server-deployment.yaml
kubectl apply -f zlux-app-server-service.yaml

kubectl expose deployment/gateway-service --type=NodePort --name=gateway-nodeport-service

kubectl get pods,svc,deployment,pvc
# kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/static/provider/do/deploy.yaml
# kubectl apply -f zowe-ingress.yaml 