# gke-interactive-parcel
GKE Example
- You can review the startall.sh in the scripts folder for the the general flow.

 - We recommend creating a helm over-ride file - don't change the values.yaml in the chart.  Reading thru the entire values.yaml is difficult and we have a new release every month and merging your changes back into the values.yaml is a maintenance headache.
   -  e.g. helm upgrade -i helm_instance_name neo4j/neo4j -f sc-standalone.yaml 
 
Pre-Requisites
- Create Storage Classes
  - Example storage class is gcp-ssd.yaml
  - Neo4j needs to wait for first consumer so that the disk is provisioned in the same zone as the pod.
  - Neo4j needs to retain the disk, so that the database can survive a helm uninstall.
  - Neo4j needs a fast disk so pd-ssd or premium-rwo is needed.
  - Allow expansion is nice, if your operations don't allow this, you will need to backup Neo4j, helm uninstall neo4j, delete the old disk and get a new larger disk, restore, etc. if you are running out of space.
    - We recommend a much larger disk that you think you need, as transaction logs, metrics and other files will need space.  100 Gi is the bare minimum and for a PoC we recommend 512 Gi
- Neo4j initial password
    - We have a sample script - createPasswordSecret.sh - this will create a secret that the chart will pick up instead of putting the password in the over-ride file    
    - Your password is baked into the system database create on first initialization.  Changing the secret will NOT change your neo4j password.  If you need to recover see https://neo4j.com/docs/operations-manual/current/authentication-authorization/password-and-user-recovery/
- Set your preferred default namespace (or edit all the scripts to include your preferred namespace)
  - From the startall.sh
    - kubectl create namespace your_neo4j_namespace
    - kubectl config set-context --current --namespace=your_neo4j_namespace


# Single, standalone Neo4j instance with GDS and Bloom Licensing

We are showing 2 distinct examples of mounting the license files.  
Both examples assume you have copied the bloom and gds license files into the licenses directory with the names bloom.license and gds.license.  
- Using a secret to hold the license files.  This follows the pattern in the manual https://neo4j.com/docs/operations-manual/current/kubernetes/plugins/#install-gds-ee-bloom
  - run ./create-licenses-secret.sh - this will take the files gds.license and bloom.license and create the secrets.
  - helm upgrade -i helm_instance_name neo4j/neo4j -f sc-standalone.yaml 
- Using a configmap to hold the license files.  
  - run ./create-licenses-configmap.sh - this will take the files gds.license and bloom.license and create the configMap.
  - helm upgrade -i helm_instance_name neo4j/neo4j -f standalone.yaml 
  
# Optional Docker Image Creation
- There are good reasons for creating a docker image with plugins copied in - we document that here https://neo4j.com/docs/operations-manual/current/kubernetes/plugins/#custom-container
  - In the docker directory is an example dockerfile and a sample script to do the build.  You will need to use your standard repository and build mechanism, but an example is in the buildNeo4j.sh file.