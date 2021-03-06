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


isCorrectType = (req, res, next) => {
    let email = req.body.username;
    // let password = req.body.password;
    let type = req.body.type;
    db.collection(type).get().then((response) => {
        response.forEach(data => {
            if (data.data().email === email)
                next();
        })
    }).catch((err) => {
        console.log('Sorry! The designation is incorrect');
    }); 
}

isEmployee = (req, res, next) => {
    let user = firebase.auth().currentUser;
        if (user) {
            var email = firebase.auth().currentUser.email;
            db.collection('Employee').get().then((response) => {
                response.forEach(data => {
                    if (data.data().email === email)
                        next();
                })
            }).catch((err) => {
                console.log('Sorry! The designation is incorrect');
            });
        }
        else{
            res.redirect('/login');
        }
}

isSick =  (req, res, next) => {
    let email = firebase.auth().currentUser.email;
    db.collection('isCurrentHealth').doc(email).get().then((data)=>{
        data = data.data();
        let date = data.date;
        let status = data.status;
        var a = (new Date(date._seconds * 1000).toDateString());
        var b = (new Date(Date.now()).toDateString());
        if (a === b)
            return next();
        else
            return res.render('employeeHealth');
    })
   
}

isHR = (req, res, next) => {
    let user = firebase.auth().currentUser;
        if (user) {
            var email = firebase.auth().currentUser.email;
            db.collection('HR').get().then((response) => {
                response.forEach(data => {
                    if (data.data().email === email)
                        next();
                })
            }).catch((err) => {
                console.log('Sorry! The designation is incorrect');
            });
        }
        else
            res.redirect('/login');
}

isManager = (req, res, next) => {
    let user = firebase.auth().currentUser;
        if (user) {
            var email = firebase.auth().currentUser.email;
            db.collection('Manager').get().then((response) => {
                response.forEach(data => {
                    if (data.data().email === email)
                        next();
                })
            }).catch((err) => {
                console.log('Sorry! The designation is incorrect');
            });
        }
        else {
            res.redirect('/login');
        }
}

app.get('/', (req, res) => {
    res.redirect('/login');
})


app.get('/manager', isManager, (req, res) => {
    let reviewtasks = []
    let reassigntasks = []
    let sickemp = {};
    let alltasks = [];
    db.collection('Health').orderBy("date", "desc").get().then((response) => {
        response.forEach((data) => {
            if (data.data().status == 'sick') {
                if (sickemp[data.data().email] != 0)
                    sickemp[data.data().email] = 1;
            } else {
                if (sickemp[data.data().email] != 1)
                    sickemp[data.data().email] = 0;
            }
        })
    }).then(() => {
        db.collection('Task').get().then((response) => {
            response.forEach((data) => {
                if ((data.data().reviewed == false) && (data.data().completed == true) && (data.data().manager == firebase.auth().currentUser.email)) {
                    let tempobj = data.data();
                    tempobj.id = data.id;
                    tempobj.deadline = new Date(tempobj.deadline._seconds * 1000).toDateString();
                    reviewtasks.push(tempobj);
                }
                if ((data.data().completed == false) && (sickemp[data.data().employee] == 1) && (data.data().manager == firebase.auth().currentUser.email)) {
                    let tempobj = data.data();
                    tempobj.id = data.id;
                    tempobj.deadline = new Date(tempobj.deadline._seconds * 1000).toDateString();
                    reassigntasks.push(tempobj);
                }
                if ((data.data().manager == firebase.auth().currentUser.email)) {
                    let tempobj = data.data();
                    alltasks.push(tempobj);
                }

            })
        }).then(() => {
            let employee = []
            db.collection('Employee').get().then((response) => {
                response.forEach((data) => {
                    employee.push(data.data());
                })
            }).then(() => {

                res.render('manager/manager', { email: firebase.auth().currentUser.displayName, reviewtasks: reviewtasks, reassigntasks: reassigntasks, employee: employee, alltasks: alltasks });
            }).catch((err) => {
                res.json(err);
            })
        })
    })
});

// Creating Tasks
app.post('/task/create', (req, res) => {
    let obj = req.body;
    obj.completed = false;
    obj.reviewed = false;
    obj.completedate = null;
    obj.taskpoints = 0;
    obj.manager = firebase.auth().currentUser.email;
    obj.totalpoints = Number(obj.totalpoints)
    obj.deadline = new Date(obj.deadline);
    obj.employee = obj.email;
    delete obj.email;
    obj.employeeComment = "N/A";
    obj.managerComment = "N/A";
    db.collection('Task').add(req.body).then(data => {
        res.redirect('/manager');
    }).catch(err => res.json({ message: 'some error occured' }))
})
// Reviewing Tasks
app.post('/task/review', (req, res) => {
    db.collection('Task').doc(req.body.id).set({
        taskpoints: Number(req.body.taskpoints),
        reviewed: true,
        managerComment: req.body.comment
    }, { merge: true }).then(() => {
        res.json({ message: 'success' })
    }).catch((err) => {
        res.json({ message: 'error' })
    })
})
// Reassign task
app.post('/task/reassign', (req, res) => {
    db.collection('Task').doc(req.body.id).set({
        taskpoints: Number(req.body.taskpoints),
        reviewed: true,
        completed: true,
        managerComment: req.body.comment,
        completedate: new Date()
    }, { merge: true }).then(() => {
        db.collection('Task').get().then((response) => {
            let obj = {};
            response.forEach((data) => {
                if (data.id == req.body.id) {
                    obj = data.data();
                }
            })
            obj.employee = req.body.email;
            obj.totalpoints = obj.totalpoints - req.body.taskpoints;
            obj.taskpoints = 0;
            if (req.body.deadline != '') {
                obj.deadline = new Date(req.body.deadline);
            }
            obj.completed = false;
            obj.completedate = null;
            obj.reviewed = false;
            obj.managerComment = null;
            db.collection('Task').add(obj).then(data => {
                res.json({ message: 'success' });
            }).catch(err => {
                res.json({ message: 'error' })
            })
        });
    });

})



// Employee Routes
app.get('/employee', isEmployee, isSick, (req, res) => {
    let tasks = [];
    let reviewed = [];
    let notCompleted = [];
    let messages = [];
    let courses = [];
    db.collection('Task').get().then((response) => {
        response.forEach(data => {
            let obj = {};
            if (data.data().employee === firebase.auth().currentUser.email) {
                obj = data.data();
                obj.id = data.id;
                tasks.push(obj);
                if (!data.data().completed) {
                    obj = data.data();
                    obj.id = data.id;
                    notCompleted.push(obj);
                }
                if (data.data().reviewed) {
                    obj = data.data();
                    obj.id = data.id;
                    reviewed.push(obj);
                }
            }
        })
    })
        .then(() => {
            db.collection('Message').orderBy('date', 'desc').get().then((response) => {
                response.forEach((data) => {
                    let tempobj = data.data();
                    if ((tempobj.read == false) && (tempobj.reciever == firebase.auth().currentUser.email)) {
                        tempobj.id = data.id;
                        tempobj.date = new Date(tempobj.date._seconds * 1000).toDateString();
                        messages.push(tempobj);
                    }
                })
            }).then(() => {
                db.collection('Course').get().then((response) => {
                    response.forEach((data) => {
                        if (data.data().employee == firebase.auth().currentUser.email) {
                            let tempobj = data.data();
                            tempobj.id = data.id;
                            courses.push(tempobj);
                        }
                    })
                }).then(() => {
                    res.render('employee', { email: firebase.auth().currentUser.displayName, tasks: tasks, reviewed: reviewed, notCompleted: notCompleted, messages: messages, courses: courses });
                })
            })

        });
});

// Show Employee Health Form
app.get('/employee/formWellBeing', isEmployee, (req, res) => {
    res.render('employeeHealth');
});
// Submit Employee Health Form
app.post('/employee/formWellBeing', async (req, res) => {
    let email = firebase.auth().currentUser.email;
    let obj = {};
    if(req.body.ques1==true){
        obj.status = 'sick';
    }else{
        obj.status = 'healthy';
    }
    obj.travelling = req.body.ques3;
    obj.description = req.body.ques4;
    obj.illness = req.body.ques2;
    obj.email = email;
    obj.date = new Date();
        db.collection('Health').add(obj).then((data)=>{
            db.collection('isCurrentHealth').doc(email).set({
                status: obj.status,
                date: new Date()
            }).then(()=>{
                res.json({message:'success'})
            })
        }).catch(err=>{
            res.json({message:'error'})
        })
    
    
})


// Show Employee report of the month
app.get('/employee/report', (req, res) => {
    let employee = []
    db.collection('Employee').get().then((response) => {
        response.forEach((data) => {
            employee.push(data.data());
        })
        res.render('employeeReport', { employee: employee })
    }).catch((err) => {
        res.json(err);
    })
});

// Generate Report and send task data
app.post('/employee/report', (req, res) => {
    let email = req.body.email;
    let month = req.body.month;
    let tasks = [];
    let monthNames = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"
    ];
    db.collection('Task').get().then((response) => {
        response.forEach((data) => {
            let obj = data.data();
            if (obj.reviewed == true && obj.employee == email) {
                obj.completedate = new Date(obj.completedate._seconds * 1000);
                obj.deadline = new Date(obj.deadline._seconds * 1000);
                if ((monthNames[obj.completedate.getMonth()] == month) && (obj.completedate.getFullYear() == (new Date()).getFullYear())) {
                    tasks.push(obj);
                }
            }
        })
    }).then(() => {
        res.json(tasks);
    })
})



// HR Routes


app.get('/hr', isHR, (req, res) => {
    let employee = [];
    let courses = [];
    db.collection('Employee').get().then((response) => {
        response.forEach((data) => {
            employee.push(data.data());
        })
    }).then(() => {
        db.collection('Course').get().then((response) => {
            response.forEach((data) => {
                let tempobj = data.data();
                tempobj.id = data.id;
                if ((tempobj.approved == false) && (tempobj.completed == true)) {
                    courses.push(tempobj);
                }
            })
        }).then(() => {
            res.render('hr/hr', { email: firebase.auth().currentUser.displayName, employee: employee, courses: courses });
        }).catch(err => {
            console.log(err)
            res.redirect('/');
        })
    })
})

app.post('/message', (req, res) => {
    db.collection('Message').add({
        reciever: req.body.email,
        message: req.body.message,
        sender: firebase.auth().currentUser.email,
        date: new Date(),
        read: false
    }).then(() => {
        res.json({ message: 'success' });
    }).catch((err) => {
        res.json({ message: 'error' })
    })
})

app.post('/employee/message', (req, res) => {
    let id = req.body.id;
    db.collection('Message').doc(id).set({
        read: true
    }, { merge: true }).then(() => {
        res.json({ message: 'success' });
    }).catch((err) => {
        res.json({ message: 'error' })
    })
})

app.post('/course/add', (req, res) => {
    let name = req.body['course-name'];
    let link = req.body['course-link'];
    let obj = {}
    obj.courseName = name;
    obj.courseLink = link;
    obj.employee = firebase.auth().currentUser.email;
    obj.hr = "N/A";
    obj.approved = false;
    obj.completed = false;
    obj.employeeComment = "N/A";
    obj.hrComment = "N/A";
    obj.certificateLink = "N/A";
    db.collection('Course').add(obj).then((data) => {
        res.redirect('/employee');
    }).catch(() => {
        res.json({ message: 'Some Error Occured' });
    })
})

app.post('/courses/complete', (req, res) => {
    db.collection('Course').doc(req.body.id).set({
        employeeComment: req.body.comment,
        completed: true,
        certificateLink: req.body.certificateLink
    }, { merge: true }).then(() => {
        res.json({ message: 'success' });
    }).catch((err) => {
        res.json({ message: 'error' })
    })
})

app.post('/courses/approve', (req, res) => {
    db.collection("Course").doc(req.body.id).set({
        approved: true,
        hrComment: req.body.comment,
        hr: firebase.auth().currentUser.email
    }, { merge: true }).then(() => {
        res.json({ message: 'success' });
    }).catch((err) => {
        res.json({ message: 'error' })
    })
})

app.post('/health/:id', (req, res) => {
    let id = req.params.id;
    let data = []
    db.collection('Health').orderBy("date", "desc").get().then((response) => {
        response.forEach((info) => {
            if (info.data().email == id) {
                let obj = info.data();
                obj.date = new Date(obj.date._seconds * 1000);
                data.push(obj);
            }
        })
        res.json(data);
    }).catch({ message: 'error' });
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

app.get('/login', (req, res) => {
    res.render('Login');
});

app.listen('3000', () => {
    console.log('Server Started at Port 3000...')
});



// app.get('/', (req,res) => {
//     res.render('sample');
// })

// app.post('/', (req, res) => {
//     let name=req.body.name;
//     var temp=db.collection('users').doc(name);hr
//     return temp.set({complaint: req.body.complaint, department: req.body.dept}).then(()=>
//     console.log('Entered')
//     );
// });


app.get('/signup', (req, res) => {
    res.render('signup');
});

app.post('/signup', async (req, res) => {
    // firebase.auth().currentUser
    let email = req.body.username;
    let password = req.body.password;
    let pass = req.body.passcon;
    let dept = req.body.dept;
    let name = req.body.name;
    let phno = req.body.phno;
    let type = req.body.type;
    if (password == pass) {
        let userCredential = await firebase.auth().createUserWithEmailAndPassword(email, password);
        //update the auth profile
        await userCredential.user.updateProfile({
            displayName: name// some displayName,
        });

        if (type == 'Employee')
            db.collection('isCurrentHealth').doc(email).set({ date: new Date(), status: 'healthy' })

        db.collection(type).add({ searchKey: name[0].toUpperCase(), department: dept, email: email, phone: phno, name: name }).then(() => {
            res.redirect('/' + type)
        });
    }
    else
        res.json({message: "Error"});
});

app.post('/login', isCorrectType, (req, res) => {
    var email = req.body.username;
    var password = req.body.password;
    var type = req.body.type;
    firebase.auth().signInWithEmailAndPassword(email, password)
        .then(async (user) => {
            if (type == 'Employee'){
                var flag = false;
                db.collection('isCurrentHealth').doc(email).get().then((data)=>{
                    data  = data.data();
                    let date = data.date;
                    let status = data.status;
                    var a = (new Date(date._seconds * 1000).toDateString());
                    var b = (new Date(Date.now()).toDateString());
                    if ((a==b)&& (status == 'sick'))    
                        flag=true;
                    if(flag)
                        return res.render('Confirmation')
                    else
                        return res.redirect('/employee');
                });     
            }
            else
                return res.redirect('/' + type);
        })
        .catch((error) => {
            var errorCode = error.code;
            var errorMessage = error.message;
            console.log(errorCode + ": " + errorMessage);
            return res.redirect('/');
        });
});

app.get('/logout', (req, res) => {
    firebase.auth().signOut().then(() => {
        console.log('Logging out');
    }).then((response) => {
        res.redirect('/login');
    }).catch((error)=> {
        var errorCode = error.code;
        var errorMessage = error.message;
        console.log(errorCode + ": " + errorMessage);
    });
});


app.post('/employee/complete', (req, res) => {
    db.collection('Task').doc(req.body.employeeID).set({
        completed: true,
        completedate: new Date(),
        employeeComment: req.body.commentBox
    }, { merge: true }).then(() => {
        res.redirect('/employee');
    }).catch((err) => {
        res.json({ message: 'error' })
    })
})

app.get('/employee/confirmation', isEmployee, (req, res) => {
    res.render('Confirmation');
})