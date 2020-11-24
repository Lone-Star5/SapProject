const express = require('express');
const ejs = require('ejs');
const app = express();
const admin=require('firebase-admin');
const bodyParser = require('body-parser');
// const serviceAccount=require('./sapproject-28227-firebase-adminsdk-hcmqw-6058543d99.json');


// admin.initializeApp({
//     credential: admin.credential.cert(serviceAccount)
//   });

// const db=admin.firestore();
app.set('view engine', 'ejs');
app.use(express.static(__dirname + "/public"));
app.use(bodyParser.urlencoded({extended: true}));


app.get('/', (req,res) => {
    res.render('landing');
})

// Manager Routes
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

app.get('/manager/report', (req,res) => {
    res.render('manager/report')
})

// Employee Routes
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


// HR Routes
app.get('/hr', (req,res) => {
    res.render('hr/hr');
})

app.post('/health/:id', (req,res)=>{
    let id = req.params.id;
    data = [{
        id: id,
        date: new Date(),
        status: 'sick'
    }]
    res.json(data);
})

// Server Listening at Port 3000
app.listen('3000', ()=>{
    console.log('Server Started at Port 3000...')
});



// app.get('/', (req,res) => {
//     res.render('sample');
// })

// app.post('/', (req, res) => {
//     let name=req.body.name;
//     var temp=db.collection('users').doc(name);
//     return temp.set({complaint: req.body.complaint, department: req.body.dept}).then(()=>
//     console.log('Entered')
//     );
// });