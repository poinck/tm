var express = require('express');
var fs = require('fs');
var app = express();
app.listen(61001);

app.get('/insert', (req, res, next) => {
    // insert new temperatures:
    // http://poinck.schedar.uberspace.de/tms/insert?date=2016-01-16 12:56&
    // inside=22000&outside=5000
    var date = req.query.date;
    var inside = req.query.inside;
    var outside = req.query.outside;

    var line = req.query.date + "," + req.query.inside + "," + req.query.outside;
    console.log(line);
    
        // TODO  write temperatures to tm_1440.csv; pro datum nur einen wert
        // zulassen
    // fs.writeFile("tm_1440.csv", value + '\n', {flag: 'a'}, (err) => {
    //     if (err) {
    //          return console.log(err);
    //     }
    //     console.log("The file was saved!");
    // });
 
        // TODO  additional parameter for shared secret for tmd and tms

    next();
});
