const express = require('express');
const ejs = require('ejs');
const app = express();
const admin=require('firebase-admin');
// const serviceAccount=require('./sapproject-28227-firebase-adminsdk-hcmqw-6058543d99.json');


// admin.initializeApp({
//     credential: admin.credential.cert(serviceAccount)
//   });

// const db=admin.firestore();
app.set('view engine', 'ejs');
app.use(express.static(__dirname + "/public"));

app.get('/', (req,res) => {
    res.send('working');
})

app.get('/employee' , (req,res) => {
    res.render('employee');
})

app.get('/manager', (req,res) => {
    tasks = [
        {
            name: 'Task 1',
            Employee: ['Employee 1', 'Employee 2'],
            points: 10,
            deadline: '2020-12-06',
            link: 'www.google.com',
            description: 'This is Task 1'
        }
    ]
    res.render('manager/manager',tasks=tasks);
})

app.listen('3000', ()=>{
    console.log('Server Started at Port 3000...')
})