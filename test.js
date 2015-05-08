var http = require('http');

var track = {
  status: true,
  sent_at:'2015-05-01-12-00-00-000'
};

var statusString = JSON.stringify(track);

var headers = {
  'Content-Type': 'application/json',
  'Content-Length': statusString.length
};

var options = {
  hostname: 'queue-monitor.herokuapp.com',
  path: '/tracks',
  method: 'POST',
  headers: headers
};

var req = http.request(options, function(res) {
  console.log('STATUS: ' + res.statusCode);
  console.log('HEADERS: ' + JSON.stringify(res.headers));
  res.setEncoding('utf8');
  res.on('data', function (chunk) {
    console.log('BODY: ' + chunk);
  });
});

req.on('error', function(e) {
  console.log('problem with request: ' + e.message);
});

console.log(statusString);
// write data to request body
req.write(statusString);
req.end();