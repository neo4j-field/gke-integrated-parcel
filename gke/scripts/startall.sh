GKE_CLUSTER_NAME=gke-interactive-parcel

# Configure via environment variables or set defaults in gcloud config (below)
#export CLOUDSDK_CORE_PROJECT="my-neo4j-project"
#export CLOUDSDK_COMPUTE_ZONE="europe-west2-a"
#export CLOUDSDK_COMPUTE_REGION="europe-west2"

#
# List the defaults
#
echo "GKE default settings"
gcloud config list

echo "Configuring kubectl to use the cluster..."
gcloud container clusters get-credentials gke-interactive-parcel --zone us-central1-c --project fieldeng-se-us-east

#
# Creating K8s namespace
#
echo "Create a neo4j namespace and configure it to be used in the current context"
kubectl create namespace neo4j
kubectl config set-context --current --namespace=neo4j

#
# Create secret for Neo4j's password - only needs created once
#
./createPasswordSecret.sh

#
# Create config map for license files
#
./create-licenses-configmap.sh
./create-licenses-secret.sh

#
# Create storage classes
#
./createStorageClass.sh

echo "Deploying Neo4j to the GKE cluster..."

#helm install standalone  neo4j/neo4j --namespace neo4j -f standalone.yaml 

# licenses via configMap
#helm upgrade -i standalone neo4j/neo4j -f standalone.yaml 

# licenses via secrets
helm upgrade -i standalone neo4j/neo4j -f sc-standalone.yaml 

echo "Deploying LB..."
kubectl apply -f standalone-lb.yaml