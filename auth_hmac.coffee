crypto = require('crypto')

pad = (n) -> if n < 10 then "0" + n else n

# Sat, 08 Oct 2011 16:55:39 GMT
timestamp = () ->
  now       = new Date()
  year      = now.getUTCFullYear()
  month     = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'][now.getUTCMonth()]
  dow       = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'][now.getUTCDay()]
  day       = pad(now.getUTCDate())
  hours     = pad(now.getUTCHours())
  minutes   = pad(now.getUTCMinutes())
  seconds   = pad(now.getUTCSeconds())
  "#{dow}, #{day} #{month} #{year} #{hours}:#{minutes}:#{seconds} GMT"

sign_request = (http_options, key, secret) ->
  return false unless http_options['headers']?
  http_options['headers']['Date'] = timestamp() unless http_options['headers']['Date']?
  canonical_string = http_options['method'] + "\n"
  canonical_string += (http_options['headers']['Content-Type'] || '') + "\n"
  canonical_string += (http_options['headers']['Content-MD5'] || '') + "\n"
  canonical_string += http_options['headers']['Date'] + "\n"
  canonical_string += http_options['path'] || ''

  hmac_signature = crypto.createHmac "sha1", secret
  hmac_signature.update canonical_string
  
  hmac_signature_base64 = hmac_signature.digest("base64")

  http_options['headers']['Authorization'] = "AuthHMAC #{key}:#{hmac_signature_base64}"

exports.sign = sign_request

