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
    res.render('landing');
})

app.get('/manager', (req,res) => {
    tasks = [
        {
            name: 'Task 1',
            employee: 'Employee 1',
            points: 0,
            totalPoints: 10,
            deadline: '2020-12-06',
            link: 'www.google.com',
            description: 'This is Task 1',
            completed: true
        },
        {
            name: 'Task 2',
            employee: 'Employee 2',
            points: 0,
            totalPoints: 20,
            deadline: '2020-12-06',
            link: 'www.google.com',
            description: 'This is Task 2',
            completed: true   
        },
        {
            name: 'Task 3',
            employee: 'Employee 3',
            points: 0,
            totalPoints: 30,
            deadline: '2020-12-06',
            link: 'www.google.com',
            description: 'This is Task 3',
            completed: true
        },

    ]
    res.render('manager/manager',tasks=tasks);
})

app.get('/employee',(req,res)=>{
    tasks=[
        {
            name: 'Task 1',
            employee: 'Employee 1',
            points: 0,
            totalPoints: 10,
            deadline: '2020-12-06',
            link: 'www.google.com',
            description: 'This is Task 1',
            completed: true   
        },
        {
            name: 'Task 2',
            employee: 'Employee 2',
            points: 0,
            totalPoints: 20,
            deadline: '2020-12-06',
            link: 'www.google.com',
            description: 'This is Task 2',
            completed: true   
        },
    ]
    res.render('employee',tasks=tasks);
});

app.get('/employee/formWellBeing',(req,res)=>{
    res.render('employeeHealth');
});

app.listen('3000', ()=>{
    console.log('Server Started at Port 3000...')
});