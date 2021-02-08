const express = require('express');
const app = express();


var mysql      = require('mysql');

function listPassengers(dbConnection, res, req) {
    dbConnection.query('SELECT * FROM passengers limit 5', function (err, results, fields) {
        if (err) {
            console.error('Encountered problem on select: ' + err.stack);
            res.send("encountered problem talking to db - try again");
            return;
        }
        // results.forEach(result => { console.log(result); });
        res.send(results);
    })
}

var connection = mysql.createConnection({
    host     : 'db-service',
    database : process.env.MYSQL_DATABASE,
    user     : process.env.MYSQL_USER,
    password : process.env.MYSQL_PASSWORD
});


console.log('trying to connect as  '+ process.env.MYSQL_USER+'@'+process.env.MYSQL_DATABASE)

connection.connect(function(err) {
    if (err) {
        console.error('Error connecting on first attempt: ' + err.stack);
        return;
    }
    console.log('Connected as id ' + connection.threadId);
})

app.get('/', (req, res) => {
     if (connection.state != 'authenticated') {
        connection = mysql.createConnection({
            host     : 'db-service',
            database : process.env.MYSQL_DATABASE,
            user     : process.env.MYSQL_USER,
            password : process.env.MYSQL_PASSWORD
        });
        connection.connect(function(err) {
            if (err) {
                console.error('Error connecting: ' + err.stack);
                res.send("encountered problem connecting to db - try again");
                return;
            }
            console.log('(Re)Connected as id ' + connection.threadId + ', calling listPassengers');
            listPassengers(connection, res, req);
        })
    } else {
        listPassengers(connection, res, req);
    }
});


app.listen(process.env.INT_APP_PORT, () => {
    console.log('Listening on port ' + process.env.INT_APP_PORT);
})