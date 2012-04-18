(function() {
  var Server,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  Server = (function() {
    var SocketListener, StreamListener;

    Server.name = 'Server';

    MobileRemote.Firefox.Server = Server;

    function Server() {
      this.stop = __bind(this.stop, this);

      this.start = __bind(this.start, this);

      this.toggle = __bind(this.toggle, this);
      this.signature = 'Mobile-Remote/0.1';
      this.port = 6670;
      this.loopbackOnly = false;
      this.filePath = null;
      this.fileRequest = null;
      this.pageRequest = null;
    }

    Server.prototype.toggle = function() {
      if (this.isRunning) {
        return this.stop();
      } else {
        return start();
      }
    };

    Server.prototype.start = function() {
      var sock;
      if (this.isRunning) {
        return;
      }
      sock = Components.classes["@mozilla.org/network/server-socket;1"];
      this.socket = sock.createInstance();
      this.socket = this.socket.QueryInterface(Components.interfaces.nsIServerSocket);
      this.socket.init(this.port, this.loopbackOnly, -1);
      this.socketListener = new SocketListener(this);
      this.socket.asyncListen(this.socketListener);
      return this.isRunning = true;
    };

    Server.prototype.stop = function() {
      if (!this.isRunning) {
        return;
      }
      this.isRunning = false;
      if (this.socket) {
        this.socket.close();
        return this.socket = null;
      }
    };

    SocketListener = (function() {

      SocketListener.name = 'SocketListener';

      function SocketListener(server) {
        this.server = server;
        this.onSocketAccepted = __bind(this.onSocketAccepted, this);

        this.onStopListening = __bind(this.onStopListening, this);

      }

      SocketListener.prototype.onStopListening = function(serv, status) {
        return this.stop();
      };

      SocketListener.prototype.onSocketAccepted = function(serv, transport) {
        var instream, listener, outstream, pump, request, response, stream;
        transport.setTimeout(1, 30);
        request = new MobileRemote.Request();
        response = new MobileRemote.Response();
        request.remote_ip = transport.host;
        outstream = transport.openOutputStream(0, 10000000, 100000);
        stream = transport.openInputStream(0, 0, 0);
        instream = Components.classes["@mozilla.org/scriptableinputstream;1"].createInstance(Components.interfaces.nsIScriptableInputStream);
        instream.init(stream);
        listener = new StreamListener(this.server, request, response, instream, outstream, stream);
        pump = Components.classes["@mozilla.org/network/input-stream-pump;1"].createInstance(Components.interfaces.nsIInputStreamPump);
        pump.init(stream, -1, -1, 1000000, 100, true);
        return pump.asyncRead(listener, null);
      };

      return SocketListener;

    })();

    StreamListener = (function() {

      StreamListener.name = 'StreamListener';

      function StreamListener(server, request, response, instream, outstream, stream) {
        this.server = server;
        this.request = request;
        this.response = response;
        this.instream = instream;
        this.outstream = outstream;
        this.stream = stream;
        this.fileHandle = __bind(this.fileHandle, this);

        this.respondWithPage = __bind(this.respondWithPage, this);

        this.respondWithFile = __bind(this.respondWithFile, this);

        this.setupRequest = __bind(this.setupRequest, this);

        this.onDataAvailable = __bind(this.onDataAvailable, this);

        this.onStopRequest = __bind(this.onStopRequest, this);

      }

      StreamListener.prototype.onStartRequest = function(request, context) {};

      StreamListener.prototype.onStopRequest = function(request, context, status) {
        this.instream.close();
        return this.outstream.close();
      };

      StreamListener.prototype.onDataAvailable = function(req, context, inputStream, offset, count) {
        var bis, rawHeaders, staticPath;
        bis = Components.classes["@mozilla.org/binaryinputstream;1"].createInstance(Components.interfaces.nsIBinaryInputStream);
        bis.setInputStream(this.stream);
        rawHeaders = bis.readBytes(count);
        bis.close();
        this.setupRequest(rawHeaders);
        staticPath = this.server.getStaticFilePath(this.request);
        if (staticPath) {
          return this.respondWithFile(staticPath);
        } else {
          return this.respondWithPage();
        }
      };

      StreamListener.prototype.setupRequest = function(rawHeaders) {
        var firstLine, line, piece, requestLines, xhr, _i, _len;
        requestLines = rawHeaders.match(/([^\r]+)\r\n/g);
        if (requestLines[0]) {
          firstLine = requestLines[0].match(/^([^\ ]+) ([^\ ]+)/);
          if (firstLine) {
            this.request.method = firstLine[1];
            this.request.setPath(firstLine[2]);
          }
        }
        for (_i = 0, _len = requestLines.length; _i < _len; _i++) {
          line = requestLines[_i];
          piece = line.split(': ');
          if (piece) {
            this.request.headers[piece[0]] = piece[1];
          }
        }
        xhr = this.request.headers['X-Requested-With'];
        return this.request.isXhr = xhr && xhr.match(/XMLHttpRequest/i) !== null;
      };

      StreamListener.prototype.respondWithFile = function(filepath) {
        var bis, bytes, chunk_size, contentType, extension, f, fis, i, mime, readbytes, readtypes;
        extension = filepath.match(/([^\.]+)$/);
        if (extension) {
          extension = extension[0];
        }
        mime = Components.classes["@mozilla.org/mime;1"].getService(Components.interfaces.nsIMIMEService);
        contentType = mime.getTypeFromExtension(extension);
        f = this.fileHandle(filepath);
        fis = Components.classes["@mozilla.org/network/file-input-stream;1"].createInstance(Components.interfaces.nsIFileInputStream);
        bis = Components.classes["@mozilla.org/binaryinputstream;1"].createInstance(Components.interfaces.nsIBinaryInputStream);
        fis.init(f, 1, 0, false);
        bis.setInputStream(fis);
        this.response.headers["Content-Length"] = f.fileSize;
        this.response.headers["Content-Type"] = contentType;
        this.response.headers['Server'] = self.signature;
        if (this.staticRequest) {
          this.server.staticRequest(this.request, this.response);
        }
        this.headers = this.response.headersString();
        this.outstream.write(this.headers, this.headers.length);
        chunk_size = 1000000;
        i = 0;
        while (true) {
          if (!(i < f.fileSize)) {
            break;
          }
          readtypes = chunk_size;
          if (i + chunk_size > f.fileSize) {
            readbytes = f.fileSize - i;
          }
          bytes = bis.readBytes(readbytes);
          this.outstream.write(bytes, bytes.length);
          i += chunk_size;
        }
        bis.close();
        this.instream.close();
        return this.outstream.close();
      };

      StreamListener.prototype.respondWithPage = function() {
        var code, webpage;
        this.response.headers["Server"] = this.signature;
        code = this.server.dynamicRequest(this.request, this.response);
        this.response.headers["Content-Length"] = code.length;
        webpage = this.response.headersString() + code;
        this.outstream.write(webpage, webpage.length);
        this.instream.close();
        return this.outstream.close();
      };

      StreamListener.prototype.fileHandle = function(path) {
        var f;
        f = Components.classes["@mozilla.org/file/local;1"].createInstance(Components.interfaces.nsILocalFile);
        f.initWithPath(path);
        return f;
      };

      return StreamListener;

    })();

    return Server;

  }).call(this);

}).call(this);
