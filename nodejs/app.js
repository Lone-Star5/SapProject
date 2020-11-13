const express = require('express');
const ejs = require('ejs');
const app = express();

app.set('view engine', 'ejs');
app.use(express.static(__dirname + "/public"));

app.get('/', (req,res) => {
    res.send('working')
})

app.get('/employee' , (req,res) => {
    res.render('employee');
})

app.listen('3000', ()=>{
    console.log('Server Started at Port 3000...')
})