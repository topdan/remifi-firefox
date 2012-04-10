MobileRemote.Controller = function(remote, request, response) {
  
  this.layout = null;
  
  this.process = function() {
    var doc = remote.currentBrowser().contentDocument;
    var uri = new MobileRemote.URI(doc.location.href);
    
    var page = this.findPage();
    var body = null;
    try {
      body = page.render(request, response);
    } catch (err) {
      Components.utils.reportError(err);
      body = remote.pages.error.render(err, request, response);
    }
    
    if (body == undefined)
      body = remote.pages.noBody.render(request, response);
    
    if (request.isXhr && request.isScript) {
      return body;
    } else if (request.isXhr) {
      return body + '<script type="text/javascript" charset="utf-8">\nsetupPages()\n</script>';
    } else {
      return withLayout(body);
    }
  }
  
  this.findPage = function() {
    if (request.path == "/home.html") {
      return remote.pages.home;
    } else if (request.path == "/" || MobileRemote.startsWith(request.path, '/apps/')) {
      return remote.pages.apps;
    } else if (MobileRemote.startsWith(request.path, '/tabs/')) {
      return remote.pages.tabs;
    } else if (MobileRemote.startsWith(request.path, '/windows/')) {
      return remote.pages.windows;
    } else if (MobileRemote.startsWith(request.path, '/controls/')) {
      return remote.pages.controls;
    } else if (MobileRemote.startsWith(request.path, '/mouse/')) {
      return remote.pages.mouse;
    } else {
      return remote.pages.notFound;
    }
  }
  
  var withLayout = function(body) {
    if (this.layout == null) {
      var code = remote.env.fileContent('/views/layout.html');
      this.layout = MobileRemote.microtemplate(code);
    }
    
    var views = new MobileRemote.Views.Base(remote.env);
    return this.layout({body: body, views: views});
  }
  
}