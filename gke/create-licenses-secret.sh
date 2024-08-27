kubectl delete secret license-secret > /dev/null 2>&1 
kubectl create secret  generic --from-file=licenses license-secret
kubectl describe secret license-secret
