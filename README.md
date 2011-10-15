# AuthHMAC -- HMAC signing for Node HTTP

## Install

<pre>
  npm install authhmac
</pre>

Or from source:

<pre>
  git clone git://github.com/cloudify/node-authhmac.git
  cd node-authhmac
  npm link
</pre>

## Super simple to use

AuthHmac provides HMAC signing for Node HTTP requests, it has been inspired by the Ruby AuthHMAC gem: https://github.com/seangeo/auth-hmac 

```javascript
var authhmac = require('authhmac');

var key = 'my hmac key';
var secret = 'my hmac secret'; 

http_options = {
  host: 'test.com',
  port: 80,
  path: '/api',
  method: 'POST',
  headers: {
    'Content-Type': 'multipart/form-data'
  }
};

authhmac.sign(http_options, key, secret);
    
var req = http.request(http_options, function(res) {
  // ...
});
```
