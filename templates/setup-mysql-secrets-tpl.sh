kubectl create secret generic db-root-credentials 	--from-literal=MYSQL_ROOT_PASSWORD=$MYSQL_ROOT_PASSWORD 

kubectl create secret generic db-user-credentials 	--from-literal=MYSQL_USER=$MYSQL_USER \
						   							--from-literal=MYSQL_PASSWORD=$MYSQL_PASSWORD 

