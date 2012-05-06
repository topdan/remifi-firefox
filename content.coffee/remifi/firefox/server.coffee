class Server
  Remifi.Firefox.Server = Server
  
  constructor: (@port) ->
    @signature = 'Mobile-Remote/0.1'
    @loopbackOnly = false

    # application-specific functions
    @filePath = null
    @fileRequest = null
    @pageRequest = null
  
  toggle: =>
    if @isRunning
      @stop()
    else
      start()
  
  start: =>
    return if @isRunning
    
    sock = Components.classes["@mozilla.org/network/server-socket;1"]
    @socket = sock.createInstance()
    @socket = @socket.QueryInterface(Components.interfaces.nsIServerSocket)
    
    @socket.init(@port, @loopbackOnly, -1)
    @socketListener = new SocketListener(@)
    @socket.asyncListen(@socketListener)
    
    @isRunning = true
    
  stop: =>
    return unless @isRunning
    
    @isRunning = false
    
    if @socket
      @socket.close()
      @socket = null
  
  class SocketListener
    
    constructor: (@server) ->
    
    onStopListening: (serv, status) =>
      @stop()
    
    onSocketAccepted: (serv, transport) =>
      transport.setTimeout(1, 30) # 30s timeout FF 1.0.0 does not allow this
      
      request = new Remifi.Request()
      response = new Remifi.Response()
      request.remote_ip = transport.host
      
      outstream = transport.openOutputStream(0, 10000000, 100000)
      stream = transport.openInputStream(0, 0, 0)
      instream = Components.classes["@mozilla.org/scriptableinputstream;1"].createInstance(Components.interfaces.nsIScriptableInputStream)
      instream.init(stream)
      
      listener = new StreamListener(@server, request, response, instream, outstream, stream)
      
      pump = Components.classes["@mozilla.org/network/input-stream-pump;1"].createInstance(Components.interfaces.nsIInputStreamPump)
      pump.init(stream, -1, -1, 1000000, 100, true) # 8 sec/100 google.gif
      pump.asyncRead(listener, null)
  
  class StreamListener
    
    constructor: (@server, @request, @response, @instream, @outstream, @stream) ->
    
    onStartRequest: (request, context) ->
    
    onStopRequest: (request, context, status) =>
      @instream.close()
      @outstream.close()
    
    onDataAvailable: (req, context, inputStream, offset, count) =>
      bis = Components.classes["@mozilla.org/binaryinputstream;1"].createInstance( Components.interfaces.nsIBinaryInputStream )
      bis.setInputStream(@stream)
      rawHeaders = bis.readBytes(count)
      bis.close()
      
      @setupRequest(rawHeaders)
      
      staticPath = @server.getStaticFilePath(@request, @response)
      if staticPath
        @respondWithFile(staticPath)
      else
        @respondWithPage()
    
    setupRequest: (rawHeaders) =>
      requestLines = rawHeaders.match(/([^\r]+)\r\n/g)
      
      if requestLines[0]
        firstLine = requestLines[0].match(/^([^\ ]+) ([^\ ]+)/)
        if firstLine
          @request.method = firstLine[1]
          @request.setPath(firstLine[2])
      
      for line in requestLines
        piece = line.split(': ')
        @request.headers[piece[0]] = piece[1] if piece
      
      xhr = @request.headers['X-Requested-With'];
      @request.isXhr = xhr && xhr.match(/XMLHttpRequest/i) != null;
    
    respondWithFile: (filepath) =>
      extension = filepath.match(/([^\.]+)$/)
      extension = extension[0] if extension
      
      mime = Components.classes["@mozilla.org/mime;1"].getService(Components.interfaces.nsIMIMEService)
      contentType = mime.getTypeFromExtension(extension)
      
      f = @fileHandle(filepath)
      fis = Components.classes["@mozilla.org/network/file-input-stream;1"].createInstance( Components.interfaces.nsIFileInputStream )
      bis = Components.classes["@mozilla.org/binaryinputstream;1"].createInstance( Components.interfaces.nsIBinaryInputStream )
      
      fis.init(f, 1, 0, false)
      bis.setInputStream(fis)
      
      @response.headers["Content-Length"] = f.fileSize
      @response.headers["Content-Type"] = contentType
      @response.headers['Server'] = @server.signature
      
      @server.staticRequest(@request, @response) if @staticRequest
      
      @headers = @response.headersString()
      @outstream.write(@headers, @headers.length)
      
      chunk_size = 1000000
      i = 0
      loop
        break unless i < f.fileSize
        
        readtypes = chunk_size
        if i+chunk_size > f.fileSize
          readbytes = f.fileSize - i
        bytes =  bis.readBytes(readbytes)
        @outstream.write(bytes, bytes.length)
        
        i += chunk_size
        
      bis.close()
      @instream.close()
      @outstream.close()
    
    respondWithPage: =>
      @response.headers["Server"] = @server.signature
      
      code = @server.dynamicRequest(@request, @response)
      @response.headers["Content-Length"] = code.length
      webpage = @response.headersString() + code
      
      @outstream.write(webpage, webpage.length)
      @instream.close()
      @outstream.close()
    
    fileHandle: (path) =>
      f = Components.classes["@mozilla.org/file/local;1"].createInstance(Components.interfaces.nsILocalFile)
      f.initWithPath(path)
      f
      