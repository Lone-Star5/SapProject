const express = require('express');
const ejs = require('ejs');
const app = express();
const admin = require('firebase-admin');
const bodyParser = require('body-parser');
const firebase = require('firebase');
const serviceAccount = require('./sapproject-28227-firebase-adminsdk-hcmqw-6058543d99.json');
const firebaseConfig = {
    apiKey: "AIzaSyAVO_K4JT6g4PyixRtAIqQEjA-hWbc77H4",
    authDomain: "sapproject-28227.firebaseapp.com",
    databaseURL: "https://sapproject-28227.firebaseio.com",
    projectId: "sapproject-28227",
    storageBucket: "sapproject-28227.appspot.com",
    messagingSenderId: "473051238037",
    appId: "1:473051238037:web:e1f4bced51a6ca5013159c",
    measurementId: "G-W49818FQKM"
};
firebase.initializeApp(firebaseConfig);


admin.initializeApp({
    credential: admin.credential.cert(serviceAccount),
    databaseURL: "https://sapproject-28227.firebaseio.com"
});
const db = admin.firestore();

app.set('view engine', 'ejs');
app.use(express.static(__dirname + "/public"));
app.use(bodyParser.urlencoded({ extended: true }));
app.use(express.json())



app.get('/', (req, res) => {
    res.render('landing');
})


app.get('/manager', (req, res) => {
    let tasks = []
    db.collection('Task').get().then((response) => {
        response.forEach((data) => {
            if ((data.data().reviewed == false) && (data.data().completed==true)) {
                let tempobj = data.data();
                tempobj.id = data.id;
                tempobj.deadline = new Date(tempobj.deadline._seconds*1000).toDateString();
                tasks.push(tempobj);
            }
        })
    }).then(()=>{
        // console.log(tasks);
        let employee = [
            {
                name: 'Employee 1',
                email: '1@gmail.com'
            },
            {
                name: 'Employee 2',
                email: '2@gmail.com'
            },
            {
                name: 'Employee 3',
                email: '3@gmail.com'
            }
        ]
        res.render('manager/manager', { tasks: tasks, employee: employee });
    })

})


// Creating Tasks
app.post('/task/create', (req, res) => {
    let obj = req.body;
    obj.completed = false;
    obj.reviewed = false;
    obj.completedate = null;
    obj.taskpoints = 0;
    obj.totalpoints = Number(obj.totalpoints)
    obj.deadline = new Date(obj.deadline);
    obj.manager = "Aman";
    obj.employee = obj.email;
    delete obj.email;
    console.log(obj);
    db.collection('Task').add(req.body).then(data => {
        res.redirect('/manager');
    }).catch(err => res.json({ message: 'some error occured' }))
})
// Reviewing Tasks
app.post('/task/review', (req, res) => {
    console.log(req.body);
    db.collection('Task').doc(req.body.id).set({
        taskpoints: Number(req.body.taskpoints),
        reviewed: true
    }, { merge: true }).then(() => {
        res.json({ message: 'success' })
    }).catch((err) => {
        res.json({ message: 'error' })
    })
})
// Reassign task
app.post('/task/reassign', (req,res) =>{
    // console.log(req.body);
    db.collection('Task').doc(req.body.id).set({
        taskpoints: Number(req.body.taskpoints),
        reviewed:true,
        completed:true,
        completedate: new Date(),
    },{merge: true}).then(()=>{
        db.collection('Task').get().then((response)=>{
            let obj={};
            response.forEach((data)=>{
                if(data.id == req.body.id){
                    obj = data.data();
                }
            })
            obj.employee = req.body.newEmployeeEmail;
            obj.totalpoints = obj.totalpoints - req.body.taskpoints;
            obj.taskpoints = 0;
            if(req.body.deadline != ''){
                obj.deadline = new Date(req.body.deadline);
            }
            obj.completed = false;
            obj.completedate = null;
            obj.reviewed = false;
            db.collection('Task').add(obj).then(data=>{
                res.json({message:'success'});
            }).catch(err=>{
                res.json({message:'error'})
            })
        });
    });
    
})



// Employee Routes
app.get('/employee', (req, res) => {
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
    ]
    res.render('employee', { tasks: tasks });
});

// Show Employee Health Form
app.get('/employee/formWellBeing', (req, res) => {
    res.render('employeeHealth');
});
// Submit Employee Health Form
app.post('/employee/formWellBeing', (req,res) => {
    let email = firebase.auth().currentUser.email;
    let obj = {};
    obj.status = req.body.ques1;
    obj.travelling = req.body.ques3;
    obj.description = req.body.ques4;
    obj.email = email;
    obj.date = new Date();
    db.collection('Health').add(obj).then(data=>{
        res.json({message:'success'});
    }).catch(err=>{
        res.json({message:'error'});
    })
})


// Show Employee report of the month
app.get('/employee/report', (req,res) => {
    let employee = [
        {
            name: 'Employee 1',
            email: '1@gmail.com'
        },
        {
            name: 'Employee 2',
            email: '2@gmail.com'
        },
        {
            name: 'Employee 3',
            email: '3@gmail.com'
        }
    ]
    res.render('employeeReport',{employee:employee})
});

// Generate Report and send task data
app.post('/employee/report', (req,res)=>{
    let email = req.body.email;
    let month = req.body.month;
    let tasks = [];
    let monthNames = ["January", "February", "March", "April", "May", "June","July", "August", "September", "October", "November", "December"
    ];
    db.collection('Task').get().then((response)=>{
        response.forEach((data)=>{
            let obj = data.data();
            // console.log(obj);
            if(obj.reviewed==true && obj.employee==email){
                obj.completedate = new Date(obj.completedate._seconds*1000);
                obj.deadline = new Date(obj.deadline._seconds*1000);
                if((monthNames[obj.completedate.getMonth()]==month) &&(obj.completedate.getFullYear() == (new Date()).getFullYear()) ){
                    tasks.push(obj);
                }
            }
        })
        console.log(tasks);
        res.json(tasks);
    })
})




app.get('/hr', (req, res) => {
    let employee=[]
    db.collection('Employee').get().then((response)=>{
        response.forEach((data)=>{
            employee.push(data.data());
        })
        res.render('hr/hr',{employee:employee});
    }).catch(err=>{
        res.redirect('/');
    })
})

app.post('/health/:id', (req, res) => {
    let id = req.params.id;
    let data = []
    db.collection('Health').get().then((response)=>{
        response.forEach((info)=>{
            if(info.data().email == id){
                console.log(info.data().email,id);
                let obj = info.data();
                obj.date = new Date(obj.date._seconds*1000);
                data.push(obj);
            }
        })
        res.json(data);
    }).catch({message:'error'});
})

// app.post('/monthlyreport/:id', (req, res) => {
//     let id = req.params.id;
//     data = [{
//         id: id,
//         date: new Date(),
//         status: 'sick'
//     },
//     {
//         id: id,
//         date: new Date(),
//         status: 'not sick'
//     }]
//     res.json(data);
// })

app.get('/employee/login', (req, res) => {
    res.render('Employee_Login');
});

app.listen('3000', () => {
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


app.get('/employee/signup', (req, res) => {
    res.render('signup');
});

app.post('/employee/signup', (req, res) => {
    let email = req.body.username;
    let password = req.body.password;
    let pass = req.body.passcon;
    let dept=req.body.dept;
    let name=req.body.name;
    let phno=req.body.phno;
    if (password == pass) {
        firebase.auth().createUserWithEmailAndPassword(email, password)
            .then((user) => {
                res.redirect('/employee')
            })
            .catch((error) => {
                var errorCode = error.code;
                var errorMessage = error.message;
                console.log(errorCode + ":" + errorMessage);
            });
        db.collection('Employee').add({Department:dept,Email:email,Phone:phno,Name:name});
    }
    else
        console.log('Password Mismatch');
});

app.post('/employee/login', (req, res) => {
    var email = req.body.username;
    var password = req.body.password;
    firebase.auth().signInWithEmailAndPassword(email, password)
        .then((user) => {
            res.redirect('/employee');
        })
        .catch((error) => {
            var errorCode = error.code;
            var errorMessage = error.message;
            console.log(errorCode + ": " + errorMessage);
            res.redirect('/employee/login');
        });
});

app.get('/logout', (req, res) => {
    firebase.auth().signOut().then(() => {
        res.redirect('/employee/login');
    }).catch(function (error) {
        var errorCode = error.code;
        var errorMessage = error.message;
        console.log(errorCode + ": " + errorMessage);
    });
});