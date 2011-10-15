(function() {
  var crypto, pad, sign_request, timestamp;
  crypto = require('crypto');
  pad = function(n) {
    if (n < 10) {
      return "0" + n;
    } else {
      return n;
    }
  };
  timestamp = function() {
    var day, dow, hours, minutes, month, now, seconds, year;
    now = new Date();
    year = now.getUTCFullYear();
    month = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'][now.getUTCMonth()];
    dow = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'][now.getUTCDay()];
    day = pad(now.getUTCDate());
    hours = pad(now.getUTCHours());
    minutes = pad(now.getUTCMinutes());
    seconds = pad(now.getUTCSeconds());
    return "" + dow + ", " + day + " " + month + " " + year + " " + hours + ":" + minutes + ":" + seconds + " GMT";
  };
  sign_request = function(http_options, key, secret) {
    var canonical_string, hmac_signature, hmac_signature_base64;
    if (http_options['headers'] == null) {
      return false;
    }
    if (http_options['headers']['Date'] == null) {
      http_options['headers']['Date'] = timestamp();
    }
    canonical_string = http_options['method'] + "\n";
    canonical_string += (http_options['headers']['Content-Type'] || '') + "\n";
    canonical_string += (http_options['headers']['Content-MD5'] || '') + "\n";
    canonical_string += http_options['headers']['Date'] + "\n";
    canonical_string += http_options['path'] || '';
    hmac_signature = crypto.createHmac("sha1", secret);
    hmac_signature.update(canonical_string);
    hmac_signature_base64 = hmac_signature.digest("base64");
    return http_options['headers']['Authorization'] = "AuthHMAC " + key + ":" + hmac_signature_base64;
  };
  exports.sign = sign_request;
}).call(this);
