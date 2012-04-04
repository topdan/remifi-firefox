MobileRemote.Controller = function(remote, request, response) {
  
  this.layout = null;
  
  this.process = function() {
    var page = this.findPage();
    var body = null;
    try {
      body = page.getBody(request, response);
    } catch (err) {
      body = remote.pages.error.getBody(err, request, response);
    }
    
    if (body == undefined)
      body = remote.pages.noBody.getBody(request, response);
    
    if (request.isXhr) {
      return body + '<script type="text/javascript" charset="utf-8">\nsetupPages()\n</script>';
    } else {
      return withLayout(body);
    }
  }
  
  this.findPage = function() {
    if (request.path == "/") {
      return remote.pages.dashboard;
    } else if (MobileRemote.startsWith(request.path, '/tabs/')) {
      return remote.pages.tabs;
    } else if (MobileRemote.startsWith(request.path, '/windows/')) {
      return remote.pages.windows;
    } else if (MobileRemote.startsWith(request.path, '/current/')) {
      return remote.pages.controls;
    } else if (MobileRemote.startsWith(request.path, '/go/')) {
      return remote.pages.go;
    } else {
      return remote.pages.notFound;
    }
  }
  
  var withLayout = function(body) {
    if (this.layout == null) {
      var content = remote.env.fileContent('/views/layout.html');
      this.layout = MobileRemote.microtemplate(content);
    }
    
    return this.layout({body: body});
  }
  
}