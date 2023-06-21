#!/bin/sh
quasar build
docker build . -t "localhost:5000/orders-frontend:$1"
docker push "localhost:5000/orders-frontend:$1"
cat ./deployment/deployment.yaml > deployment.tmp.yaml
sed -i '' "s/{{version}}/$1/g" deployment.tmp.yaml
kubectl apply \
  -f deployment/service-account.yaml \
  -f deployment/service.yaml \
  -f deployment/ingress.yaml \
  -f deployment.tmp.yaml

rm deployment.tmp.yaml
kubectl rollout status deployment/orders-frontend -n microservices-workshop
