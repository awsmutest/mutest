// use the express framework


var express = require('express');
var app = express();

var fs = require('fs');
var code_hash = fs.readFileSync('code_hash.txt','utf8');
console.log (code_hash);
console.log('The IPADDRESS is:', process.env.IP);
console.log('The message is:', process.env.AZ);
console.log('The hash is: %s', code_hash);
console.log(process.env.value, 'test2');

var ipaddress = process.env.IP;
var message = process.env.TEST;

// morgan: generate apache style logs to the console
var morgan = require('morgan')
app.use(morgan('combined'));

// express-healthcheck: respond on /health route for LB checks
app.use('/health', require('express-healthcheck')());

// main route
app.get('/', function (req, res) {
  res.set({
  'Content-Type': 'text/plain'
})
  res.send(`Node.js backend: Hello!! from ${message} commit ${code_hash}`);
  // res.send(`Hello World! from ${ipaddress} in AZ-${az} which has been up for ` + process.uptime() + 'ms');
});

// health route - variable subst is more pythonic just as an example
var server = app.listen(3000, function() {
  var port = server.address().port;
  console.log('Example app listening on port %s!', port);
});

// export the server to make tests work
module.exports = server;


// ------------------------------------------------

'use strict';
const aws = require('aws-sdk');
var kms = new aws.KMS();
 
exports.martin = (event, context, callback) => {
  kms.decrypt({CiphertextBlob:
    new Buffer(process.env.value, 'base64')},
    (err, data) => {
 
    var value = data.Plaintext.toString('ascii');
 
    /*
     * Do stuff with plaintext password
     */
 
    callback(null, {
      statusCode: 200,
      body: JSON.stringify("hello"),
      headers: {
          'Content-Type': 'application/json',
      },
    });
 
  });
};
