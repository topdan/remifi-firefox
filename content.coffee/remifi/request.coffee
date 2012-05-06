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
    @isScript = Remifi.endsWith(@path, '.js');
    
    if @params
      for key, value of @params
        @params[key] = decodeURIComponent(value);
    
    path
    
  cleanPath: (path) =>
    # app uses GET to pass in data, which uses '+' instead of '%20'
    path.replace(/\+/g, '%20');
    