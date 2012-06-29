class Request
  Remifi.Request = Request
  
  constructor: ->
    @remote_ip = null;
    @headers = {};
    @fullpath = null;
    @path = null;
    @params = null;
  
  setPath: (path) =>
    @fullpath = path;
    
    smoothPath = this.cleanPath(path);
    # Components.utils.reportError(smoothPath);
    
    uri = new Remifi.URI("http://local.remifi.com#{smoothPath}")
    @params = uri.queryKey;
    @path = uri.path;
    @isScript = Remifi.endsWith(@path, '.js')
    @isJSON = Remifi.endsWith(@path, '.json')
    
    if @params
      for key, value of @params
        @params[key] = decodeURIComponent(value);
    
    path
    
  cleanPath: (path) =>
    # app uses GET to pass in data, which uses '+' instead of '%20'
    path.replace(/\+/g, '%20');
  
  processHeaders: (rawHeaders) =>
    requestLines = rawHeaders.match(/([^\r]+)\r\n/g)

    if requestLines[0]
      firstLine = requestLines[0].match(/^([^\ ]+) ([^\ ]+)/)
      if firstLine
        @method = firstLine[1]
        @setPath(firstLine[2])

    for line in requestLines
      piece = line.split(': ')
      @headers[piece[0]] = piece[1] if piece

    xhr = @headers['X-Requested-With']
    @isXhr = xhr && xhr.match(/XMLHttpRequest/i) != null
    