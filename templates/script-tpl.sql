

CREATE TABLE passengers (
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,  # autogenerated unique id
    survived  SMALLINT NOT NULL,
    pclass SMALLINT NOT NULL,
    name VARCHAR(100) NOT NULL,
    sex CHAR (7) NOT NULL,   
    age SMALLINT NOT NULL,
    relativesaboard SMALLINT NOT NULL,
    parentskidsaboard SMALLINT NOT NULL,
    fare DECIMAL (7,2) NOT NULL
);

LOAD DATA  INFILE '/data/titanic.csv'
INTO TABLE passengers
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(survived, pclass, name, sex, age, relativesaboard, parentskidsaboard, fare)
SET id = NULL;

CREATE INDEX idx_name
ON passengers (name);

CREATE INDEX idx_id
ON passengers (id);

alter user '$MYSQL_USER' identified with mysql_native_password by '$MYSQL_PASSWORD'; 

CREATE TABLE health (
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY);  # dummy table to have something to read from

create user 'reader' identified by 'Iamthereader'; # this user will be used for healthchecks
alter user 'reader' identified with mysql_native_password by 'Iamthereader'; 
grant select, show view on health to 'reader'; 


