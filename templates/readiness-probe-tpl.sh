

# This script executes as liveness and readiness probe for mysql container

OPTIONS="--protocol=TCP --port=3306 --database=$MYSQL_DATABASE -u reader -pIamthereader "

echo "checking if mysql  is up and ready"
mysql  ${DOLLAR}OPTIONS -e 'select count(*) from health;'



