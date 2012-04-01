if (MobileRemote.Firefox == null) MobileRemote.Firefox = {}

MobileRemote.Firefox.Server = function() {
  var self = this;
  
  this.port = 6670;
  this.loopbackOnly = false;
  
  // application-specific functions;
  this.filePath = null;
  this.fileRequest = null;
  this.pageRequest = null;
  
  this.toggle = function() {
    if (this.isRunning)
      this.stop();
    else
      this.start();
  }
  
  this.start = function() {
    if (this.isRunning)
      return;
    
    var sock = Components.classes["@mozilla.org/network/server-socket;1"];
    this.socket = sock.createInstance();
    this.socket = this.socket.QueryInterface(Components.interfaces.nsIServerSocket);
    
    this.socket.init(this.port, this.loopbackOnly, -1);
    this.socketListener = new SocketListener();
    this.socket.asyncListen(this.socketListener);
    
    this.isRunning = true;
  }
  
  this.stop = function() {
    if (!this.isRunning)
      return;
    
    this.isRunning = false;
    
    if (this.socket) {
      this.socket.close();
      this.socket = null;
    }
  }
  
  var SocketListener = function() {
    
    this.onStopListening = function(serv, status) {
      self.stop();
    },
    
    this.onSocketAccepted = function(serv, transport) {
      transport.setTimeout(1, 30); // 30s timeout FF 1.0.0 does not allow this
      
      var request = new MobileRemote.Request();
      var response = new MobileRemote.Response();
      request.remote_ip = transport.host;
      
      var outstream = transport.openOutputStream(0, 10000000, 100000);
      var stream = transport.openInputStream(0, 0, 0);
      var instream = Components.classes["@mozilla.org/scriptableinputstream;1"].createInstance(Components.interfaces.nsIScriptableInputStream);
      instream.init(stream);
      
      var listener = new StreamListener( request, response, instream, outstream, stream );
      
      var pump = Components.classes["@mozilla.org/network/input-stream-pump;1"].createInstance(Components.interfaces.nsIInputStreamPump);
      pump.init(stream, -1, -1, 1000000, 100, true); // 8 sec/100 google.gif
      pump.asyncRead(listener, null);
    }
  }
  
  var StreamListener = function( request, response, instream, outstream, stream ) {
    
    this.onStartRequest = function(request, context) { }

    this.onStopRequest = function(request, context, status) {
      instream.close();
      outstream.close();
    }
    
    this.onDataAvailable = function(req, context, inputStream, offset, count) {
      var bis = Components.classes["@mozilla.org/binaryinputstream;1"].createInstance( Components.interfaces.nsIBinaryInputStream );
      bis.setInputStream(stream);
      var rawHeaders = bis.readBytes(count);
      bis.close();
      
      setupRequest(rawHeaders);
      
      var staticPath = self.getStaticFilePath(request);
      if (staticPath) {
        respondWithFile(staticPath);
      } else {
        respondWithPage();
      }
    }
    
    var setupRequest = function(rawHeaders) {
      var requestLines = rawHeaders.match(/([^\r]+)\r\n/g);
      
      if (requestLines[0]) {
        var firstLine = requestLines[0].match(/^([^\ ]+) ([^\ ]+)/);
        if (firstLine) {
          request.method = firstLine[1];
          request.setPath(firstLine[2]);
        }
      }
      
      for (var i=1 ; i < requestLines.length ; i++) {
        var piece = requestLines[i].split(': ');
        if (piece) {
          request.headers[piece[0]] = piece[1];
        }
      }
      
      var xhr = request.headers['X-Requested-With'];
      request.isXhr = xhr && xhr.match(/XMLHttpRequest/i) != null;
    }
    
    var respondWithFile = function(filepath) {
      var extension = filepath.match(/([^\.]+)$/);
      if (extension)
        extension = extension[0];
      
      var mime = Components.classes["@mozilla.org/mime;1"].getService(Components.interfaces.nsIMIMEService);
      var contentType = mime.getTypeFromExtension(extension);
      
      var f = fileHandle(filepath);
      var is = Components.classes["@mozilla.org/network/file-input-stream;1"].createInstance( Components.interfaces.nsIFileInputStream );
      var bis = Components.classes["@mozilla.org/binaryinputstream;1"].createInstance( Components.interfaces.nsIBinaryInputStream );
      
      is.init(f, 1, 0, false);
      bis.setInputStream(is);
      
      response.headers["Content-Length"] = f.fileSize;
      response.headers["Content-Type"] = contentType;
      
      self.staticRequest(request, response);
      
      var headers = response.headersString();
      outstream.write(headers, headers.length);
      
      var chunk_size = 1000000;
      for(var i=0;i<f.fileSize;i+=chunk_size) {
        var readbytes = chunk_size;
        if (i+chunk_size > f.fileSize) {
          readbytes = f.fileSize - i;
        }
        var bytes =  bis.readBytes(readbytes);
        outstream.write(bytes, bytes.length);
      }
      bis.close();
      instream.close();
      outstream.close();
    }
    
    var respondWithPage = function() {
      var content = self.dynamicRequest(request, response);
      response.headers["Content-Length"] = content.length;
      
      var webpage = response.headersString() + content;
      
      outstream.write(webpage, webpage.length);
      instream.close();
      outstream.close();
    }
    
    var fileHandle = function(path) {
      var f = Components.classes["@mozilla.org/file/local;1"].createInstance(Components.interfaces.nsILocalFile);
      f.initWithPath(path);
      return f;
    }
    
  }
  
}