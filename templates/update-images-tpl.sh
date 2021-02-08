kubectl set image sts/ss-mysql ss-mysql=$DOCKER_USER/cs-exam-mysql:$SHA 
kubectl set image deploy/cs-app app-c=$DOCKER_USER/cs-exam-app:$SHA