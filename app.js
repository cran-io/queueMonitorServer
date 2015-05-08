var http = require('http'),
    httpProxy = require('http-proxy');
 
var proxy = httpProxy.createProxyServer({});

var server = http.createServer(function(req, res) {
  // You can define here your custom logic to handle the request 
  // and then proxy the request. 
  delete req.headers.host;
  console.log(req.url);
  proxy.web(req, res, { target: 'http://queue-monitor.herokuapp.com' });
});
 
console.log("listening on port 5000")
server.listen(5000);