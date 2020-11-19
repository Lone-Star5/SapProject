const express = require('express');
const ejs = require('ejs');
const app = express();
const admin=require('firebase-admin');
const serviceAccount=require('./sapproject-28227-firebase-adminsdk-hcmqw-6058543d99.json');


admin.initializeApp({
    credential: admin.credential.cert(serviceAccount)
  });

const db=admin.firestore();
app.set('view engine', 'ejs');
app.use(express.static(__dirname + "/public"));

app.get('/', (req,res) => {
    res.send('working');
})

app.get('/employee' , (req,res) => {
    res.render('employee');
})

app.get('/manager', (req,res) => {
    res.render('manager/manager');
})

app.listen('3000', ()=>{
    console.log('Server Started at Port 3000...')
})