#!/bin/sh
quasar build
docker build . -t "localhost:5000/orders-frontend:$1"
docker push "localhost:5000/orders-frontend:$1"
cat ./deployment/deployment-canary.yaml > deployment.tmp.yaml
sed -i '' "s/{{version}}/$1/g" deployment.tmp.yaml
kubectl apply -f deployment.tmp.yaml

rm deployment.tmp.yaml
kubectl rollout status deployment/orders-frontend-canary -n microservices-workshop
