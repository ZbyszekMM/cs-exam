#!/bin/bash
# this script performs all non google cloud prep steps and should be run first

# CHANGE  values of the following variables as needed


export DOCKER_USER=zbyszekm
export MYSQL_DATABASE=cs-exam   
export INT_APP_PORT=3000   # internal port (container port) on which the node app should listen
export EXT_APP_PORT=80     # port on which node app should be available outside of the container / K8s cluster




# DO NOT TOUCH BELOW THIS LINE
################################################################################

if [ ! -e db-pswds.sh ]
then 
   echo "db-pswds.sh with mysql initial users setting does not exist. Terminating .."
   exit 1
fi

source ./db-pswds.sh # set mysql passwords related env variables
if [ -z $MYSQL_ROOT_PASSWORD ]
then 
   echo "MYSQL_ROOT_PASSWORD env variable not set in db-pswds.sh. Terminating .."
   exit 1
fi

if [ -z $MYSQL_USER ]
then 
   echo "MYSQL_USER env variable not set in db-pswds.sh. Terminating .."
   exit 1
fi

if [ -z $MYSQL_PASSWORD ]
then 
   echo "MYSQL_PASSWORD env variable not set in db-pswds.sh. Terminating .."
   exit 1
fi

export SHA=$(git rev-parse HEAD)

WARNING="# THIS FILE WAS GENERATED FROM A TEMPLATE, DO NOT TOUCH IT. Template file is in /templates"



###### PHASE - prepare yamls and shell scripts 

export DOLLAR='$'  # needed to escape some envsubst substitions

echo $WARNING > .env
envsubst < templates/.env-tpl >> .env   # environment vars for docker-compose of mysql

echo $WARNING > ./db/data/readiness-probe.sh
envsubst < templates/readiness-probe-tpl.sh >> ./db/data/readiness-probe.sh  # mysql startup hook command 
chmod +x ./db/data/readiness-probe.sh

echo $WARNING > ./db/data/scripts/script.sql
envsubst < templates/script-tpl.sql >> ./db/data/scripts/script.sql  
echo $WARNING >> ./db/data/scripts/script.sql

echo $WARNING > ./k8/stateful-set.yaml
envsubst < templates/stateful-set-tpl.yaml >> ./k8/stateful-set.yaml  

echo $WARNING > ./k8/app.yaml
envsubst < templates/app-tpl.yaml >> ./k8/app.yaml  

echo $WARNING > ./k8/load-balancer.yaml
envsubst < templates/load-balancer-tpl.yaml >> ./k8/load-balancer.yaml

echo $WARNING > ./k8/setup-mysql-secrets.sh
envsubst < templates/setup-mysql-secrets-tpl.sh >> ./k8/setup-mysql-secrets.sh  # generates kubectl command for secrets
chmod +x ./k8/setup-mysql-secrets.sh

echo $WARNING > ./update-images.sh
envsubst < templates/update-images-tpl.sh >> ./update-images.sh  
chmod +x ./update-images.sh


###### PHASE - login to docker
echo "logging in to docker as $DOCKER_USER"
docker login -u $DOCKER_USER
if [ $? -ne 0 ]
then 
   echo "docker login failed"
   exit 1
fi


###### PHASE - create customized mysql container - it has everything prepared for data upload. We will use this on k8s cluster

docker-compose build 
if [ $? -ne 0 ]
then 
   echo "local build with docker failed"
   exit 1
fi

echo "pushing $DOCKER_USER/cs-exam-mysql:$SHA to docker hub"
docker push $DOCKER_USER/cs-exam-mysql:$SHA
docker image tag $DOCKER_USER/cs-exam-mysql:$SHA $DOCKER_USER/cs-exam-mysql:latest
docker push $DOCKER_USER/cs-exam-mysql:latest

echo "pushing $DOCKER_USER/cs-exam-app:$SHA to docker hub"
docker push $DOCKER_USER/cs-exam-app:$SHA
docker image tag $DOCKER_USER/cs-exam-app:$SHA $DOCKER_USER/cs-exam-app:latest
docker push $DOCKER_USER/cs-exam-app:latest





