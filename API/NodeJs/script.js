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
 
    connection.query('INSERT INTO Users(email, password) values(?,?)',[req.body.email, req.body.password], (error, rows, fields, response) =>{
        if(!error){
            console.log('Successfully created new account.');
            res.json({
                "status": "success",
                "user_id": rows["insertId"]
            });
        }else{
            console.log('User already exists.');
            res.json({"status": "failed"});
            throw error;
        }
    })
});

//sign_in endpoint
app.post('/login', function(req, res){
    connection.query('SELECT * FROM Users WHERE email=? AND password=?',[req.body.email, req.body.password], (error, rows, fields, response) =>{
        
        if(!!error){
            console.log('Failed to sign in');
            res.send({"status": "success"});
            throw error;
        }else{
            console.log('Successfully signed in');
            // res.send({"status": "success"});
            res.send(rows);
        }
        
    })
});

//save_weight endpoint
app.post('/save_weight', function(req, res){
    connection.query('INSERT INTO Weight(weight,created_on,user_id) values(?,?,?)',[req.body.weight, req.body.created_on, req.body.user_id], (error, response) =>{
        if(!!error){
            console.log('Failed to save weight');
            res.send({"status": "fail"});
            throw error;
        }else{
            console.log('Weight successfully saved');
            res.send({"status": "success"});
        }
        return response;
    })
});

//get_weight endpoint
app.get('/get_weight/:user_id', function(req, res){
    connection.query('SELECT * FROM weight WHERE user_id = ? ORDER BY id DESC',[req.params.user_id], function(error, rows, field){
        if(!error){
            console.log('Successful query');
            console.log(rows);
            res.send(rows);
        }else{
            console.log('Error in query');
            res.send(error);
        }
    }); 
});

//delete weight
app.delete('/delete_weight/:id', function(req, res){
    connection.query('DELETE FROM Weight WHERE id = ?',[req.params.id], function(error, rows, field){
    
        if(!!error){
            console.log('Failed to delete weight');
            console.log(error);
            res.send({"status": "fail"});

        }else{
            console.log('Weight with ID: ${[req.params.id]} was successfully deleted.');
            console.log(rows);
            res.send({"status": "success"});
        }
    }); 
});

//update_weight
app.put('/update_weight/:id', function(req, res){
    connection.query('UPDATE weight SET weight=? WHERE id=?',[req.body.weight,req.params.id], function(error, response, rows, fields){

        if(!error){
            res.send('Record succesfully updated!');
            console.log('Record succesfully updated!');
            console.log(rows);
            console.log(response.affectedRows + " record(s) updated");
        }else{
            console.log('Failed to update record.');
            res.send(error);
        }
    });
});

