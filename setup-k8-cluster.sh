# this script sets up K8s cluster. 
# change the env variables below as needed

export GCP_PROJECT_ID=gc-cs-exam
export GCP_ZONE=europe-west1-b
export GKE_CLUSTER=eretz
export GKE_NODES=2

# DO NOT TOUCH BELOW THIS LINE
################################################################################

gcloud auth login
if [ $? -ne 0 ]
then 
   echo "gcloud login failed"
   exit 1
fi

gcloud config set project $GCP_PROJECT_ID
if [ $? -ne 0 ]
then 
   echo "failed to set gcloud project"
   exit 1
fi

gcloud config set compute/zone $GCP_ZONE
if [ $? -ne 0 ]
then 
   echo "failed to set gcloud zone"
   exit 1
fi

gcloud container clusters create $GKE_CLUSTER --num-nodes=$GKE_NODES
if [ $? -ne 0 ]
then 
   echo "failed to  create $GKE_CLUSTER cluster in zone $GCP_ZONE in project $GCP_PROJECT_ID"
   exit 1
fi

gcloud container clusters get-credentials $GKE_CLUSTER

./k8/setup-mysql-secrets.sh
kubectl apply -f ./k8/storage-class.yaml
kubectl apply -f ./k8/headless-service.yaml
kubectl apply -f ./k8/stateful-set.yaml
kubectl apply -f ./k8/app.yaml
kubectl apply -f ./k8/load-balancer.yaml


PORT=`kubectl get svc cs-lb-service  --no-headers -ocustom-columns='IP:spec.ports[0].port'`
echo 
echo "use EXTERNAL-IP:$PORT to reach the application when EXTERNAL-IP becomes defined below"
echo "use CTRL-C to stop watching ..."
kubectl get svc cs-lb-service -w
IP=`kubectl get svc cs-lb-service  --no-headers -ocustom-columns='IP:status.loadBalancer.ingress[0].ip'`
echo "$IP:$PORT" 





