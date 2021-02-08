# WEAKNESS TO ADDRESS (image tag)
FROM mysql:8.0.23

# this will override the most unfortunate value of secure_file_priv (null in the original mysql image), 
# preventing sql LOAD command to work

WORKDIR /etc/mysql/conf.d/
COPY ./dbconf/ .  

WORKDIR /data

# copy scripts and passengers data 
COPY ./data/ .

# some more copy/move, corrects file / directories ownership
RUN ./apply-db-conf.sh

USER mysql:mysql