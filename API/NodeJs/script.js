var mysql = require('mysql');
var express = require('express');
var app = express();

//Enables us to pass json objects
app.use(express.urlencoded({ extended: false }));
app.use(express.json()); 

app.use((req, res, next)=>{
    res.header('Access-Control-Allow-Origin', '*');
    res.header('Access-Control-Allow-Headers','*');

    if(req.method === 'OPTIONS'){
        res.header('Access-Control-Allow-Methods', 'GET, POST, PUT, PATCH, DELETE');
        return res.status(200).json({});
    }
    next();
});

var connection = mysql.createConnection({
    host: 'localhost',
    user: 'root',
    password: '',
    database: 'doshex'
});

connection.connect(function(error){
    if(!!error){
        console.log('There was an error connecting to the server.');
    }else{
        console.log('Successfully connected to the server.');
    }
});

app.listen(3000, ()=>console.log('CORS-enabled and Express Server is running on localhost:3000'));