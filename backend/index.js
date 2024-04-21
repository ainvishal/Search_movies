const express = require('express');
const app = express();
const cors = require('cors');
const port = 3000;
const mainRoute = require('./routes/routes');

app.use(cors({
    methods: "GET,HEAD,PUT,PATCH,POST,DELETE",
}))
app.use(express.urlencoded({extended:true}))
app.use(express.json())


app.use('/api/v1', mainRoute);

app.listen(port, () => {
    console.log("The server is up and running")
})