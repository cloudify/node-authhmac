vows = require 'vows'
assert = require 'assert'
authhmac = require '../auth_hmac'

vows
  .describe('AuthHMAC')
  .addBatch
    'when an HTTP request':
      
      'with empty options':
        topic: -> {}
        
        'is signed':
          topic: (topic) ->
            authhmac.sign(topic, 'key', 'secret')
          'we get false': (topic) ->
            assert.equal topic, false
      
      'with valid fields':
        topic: -> 
          method: 'GET'
          path: '/hello'
          headers:
            'Content-Type': 'text/plain'
            'Date': 'Tue, 18 Oct 2011 15:26:09 GMT'
        'is signed':
          topic: (topic) ->
            authhmac.sign(topic, 'key', 'secret')
            topic
          'the Authorization header gets filled with the signature': (topic) ->
            assert.equal topic.headers['Authorization'], 'AuthHMAC key:zkd2pWoK0TuYJ3stXGtQ1vLw8Gc='
        
        'but missing Date header':
          'is signed':
            topic: (topic) ->
              authhmac.sign(topic, 'key', 'secret')
              topic
            'the Date header gets filled': (topic) ->
              # Tue, 18 Oct 2011 15:26:09 GMT
              assert.notEqual topic.headers['Date'], undefined
              assert.ok topic.headers['Date'].match(/^\w{3}, \d{2} \w{3} \d{4} \d{2}:\d{2}:\d{2} GMT$/)


  .export(module)