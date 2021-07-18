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

//sign_up endpoint
app.post('/sign_up', function(req, res){
 
    connection.query('INSERT INTO Users(email, password) values(?,?)',[req.body.email, req.body.password], (error, response) =>{
        if(!error){
            console.log('Successfully created new account.');
            res.send('Successfully created new account.');
        }else{
            console.log('User already exists.');
            res.send('User already exists.');
            throw error;
        }
    })
});

//sign_in endpoint
app.post('/login', function(req, res){
    connection.query('SELECT * FROM Users WHERE email=? AND password=?',[req.body.email, req.body.password], (error, row, fields, response) =>{
        
        if(!!error){
            console.log('Failed to sign in');
            throw error;
        }else{
            console.log('Successfully signed in');
            res.send('Successfully signed in');
            
            console.log(req.body);
        }
        
    })
});

//save_weight endpoint
app.post('/save_weight', function(req, res){
    connection.query('INSERT INTO Weight(weight,created_on,user_id) values(?,?,?)',[req.body.weight, req.body.created_on, req.body.user_id], (error, response) =>{
        if(!!error){
            console.log('Failed to save weight');
            throw error;
        }else{
            console.log('Weight successfully saved');
            res.send('Weight successfully saved');
        }
        return response;
    })
});

