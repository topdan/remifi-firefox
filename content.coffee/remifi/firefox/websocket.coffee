class Websocket
  Remifi.Firefox.Websocket = Websocket
  
  `
  var stringToBytes = function( str ) {
    var ch, st, re = [];
    for (var i = 0; i < str.length; i++ ) {
      ch = str.charCodeAt(i);  // get char 
      st = [];                 // set up "stack"
      do {
        st.push( ch & 0xFF );  // push byte to stack
        ch = ch >> 8;          // shift value down by 1 byte
      }  
      while ( ch );
      // add stack contents to result
      // done because chars have "wrong" endianness
      re = re.concat( st.reverse() );
    }
    // return an array of bytes
    return re;
  }
  `
  # socket = new WebSocket("ws://localhost:6678") ; socket.onerror = function(evt) { asdf = evt ; console.log("as: " + evt) } ; socket.onmessage = function(evt) {  console.log(evt.data) }
  # http://stackoverflow.com/questions/3176442/using-sockets-nsiserversocket-in-xpcom-component-firefox-extension-sockets
  
  constructor: (@port) ->
    @signature = 'Mobile-Remote/0.1'
    @loopbackOnly = false

    # application-specific functions
    @handler = null
    
  toggle: =>
    if @isRunning
      @stop()
    else
      start()
  
  start: =>
    return if @isRunning
    
    listener = new MySocketListener(this)
    
    @socket = Cc["@mozilla.org/network/server-socket;1"].createInstance(Ci.nsIServerSocket)
    @socket.init(@port, true, 5)
    @socket.asyncListen(listener)
    
    Components.utils.reportError("Remifi running on port " + @socket.port)
    @isRunning = true
  
  stop: =>
    return unless @isRunning
    
    @isRunning = false
    
    if @socket
      @socket.close()
      @socket = null
  
  class MySocketListener
    
    constructor: (@server) ->
    
    onSocketAccepted: (serverSocket, clientSocket) ->
      Components.utils.reportError("Accepted websocket: "+clientSocket.host+":"+clientSocket.port)
      @input = clientSocket.openInputStream(0, 0, 0).QueryInterface(Ci.nsIAsyncInputStream)
      @output = clientSocket.openOutputStream(Ci.nsITransport.OPEN_BLOCKING, 0, 0)
      @wait()
    
    onStopListening: (serv, status) =>
      @isOpen = false

    onInputStreamReady: (input) =>
      if @isOpen
        data = @pumpWebsocket(input)
        @server.handler(data)
        
        @wait()
        
      else
        request = new Remifi.Request()
        response = new Remifi.Response()
        
        rawHeaders = @pumpStream(input)
        request.processHeaders(rawHeaders)
        
        @respond(request, response)
        @isOpen = true
        @wait()
    
    wait: () =>
      tm = Cc["@mozilla.org/thread-manager;1"].getService();
      @input.asyncWait(this,0,0,tm.mainThread);
    
    pumpStream: (input) =>
      sin = Cc["@mozilla.org/scriptableinputstream;1"].createInstance(Ci.nsIScriptableInputStream)
      sin.init(input)
      sin.available()
      request = ''
      while sin.available()
        request = request + sin.read(512)
      return request
    
    # http://stackoverflow.com/questions/8125507/how-can-i-send-and-receive-websocket-messages-on-the-server-side
    pumpWebsocket: (input) =>
      data = @pumpStream(input)
      bytes = stringToBytes(data)
      
      secondByte = bytes[1]
      
      length = secondByte & 127 # may not be the actual length in the two special cases
      
      indexFirstMask = 2        # if not a special case
      
      if length == 126          # if a special case, change indexFirstMask
        indexFirstMask = 4
      else if length == 127     # ditto
        indexFirstMask = 10
      
      masks = bytes.slice(indexFirstMask, indexFirstMask+4) # four bytes starting from indexFirstMask
      
      indexFirstDataByte = indexFirstMask + 4 # four bytes further
      
      return unless bytes.length - indexFirstDataByte > 0
      decoded = new Array(bytes.length - indexFirstDataByte)
      
      i = indexFirstDataByte
      j = 0
      while i < bytes.length
        decoded[j] = String.fromCharCode(bytes[i] ^ masks[j % 4])
        i++
        j++
      
      decoded.join("")
      
    
    respond: (request, response) =>
      if request.headers['Upgrade'] && request.headers['Upgrade'].match(/^websocket/)
        @respondWithWebsocket(request, response)
      else
        # only respond to websocket requests
        @input.close()
        @output.close()
    
    respondWithWebsocket: (request, response) =>
      webSocketKey = request.headers['Sec-WebSocket-Key']
      request.websocket = true

      response.code = 101
      response.message = 'Switching Protocols'
      response.headers['Upgrade'] = 'websocket'
      response.headers['Connection'] = 'Upgrade'
      response.headers['Sec-WebSocket-Accept'] = @webSocketKey(webSocketKey)

      webpage = response.headersString()

      @output.write(webpage, webpage.length)
      
    webSocketKey: (key) =>
      return unless key

      key = key.match(/(^[^\r\n]+)/)[1]
      magic = "258EAFA5-E914-47DA-95CA-C5AB0DC85B11"
      str = "#{key}#{magic}"

      # https://developer.mozilla.org/en/nsICryptoHash
      converter =  Components.classes["@mozilla.org/intl/scriptableunicodeconverter"].createInstance(Components.interfaces.nsIScriptableUnicodeConverter)  
      converter.charset = "UTF-8"
      result = {}
      data = converter.convertToByteArray(str, result)
      ch = Components.classes["@mozilla.org/security/hash;1"].createInstance(Components.interfaces.nsICryptoHash) 
      ch.init(ch.SHA1)
      ch.update(data, data.length)
      ch.finish(true)
      