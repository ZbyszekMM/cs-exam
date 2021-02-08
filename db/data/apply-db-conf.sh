
# data to be uploaded to mysql will be temporarily stored here. Security settings should allow mysql read / write .
chown -R mysql:mysql /data
chmod 750 /data
chmod +x /data/apply-db-conf.sh # the 

# if there is a .sql scipt(s) in the target dir below, it will be executed on mysql initialization
# the script to be envoked contains data upload to mysql and some house keeping

mv /data/scripts/script.sql /docker-entrypoint-initdb.d/

# we will run mysql as mysql user. He(?) needs access to the datadir  below

#chown -R mysql /var/lib/mysql
