MobileRemote.Controller = function(remote, request, response) {
  
  this.layoutTop = null;
  this.layoutBottom = null;
  this.notFoundBodyHTML = null;
  this.noBodyHTML = null;
  
  this.process = function() {
    var route = this.findRoute();
    var body = route.getBody(request, response);
    
    if (body == undefined)
      body = this.noBody();
    
    if (request.isXhr) {
      return body + '<script type="text/javascript" charset="utf-8">\nsetupPages()\n</script>';
    } else {
      return withLayout(body);
    }
  }
  
  this.findRoute = function() {
    if (request.path == "/") {
      return new MobileRemote.Pages.Dashboard(remote);
    } else if (MobileRemote.startsWith(request.path, '/tabs/')) {
      return new MobileRemote.Pages.Tabs(remote);
    } else if (MobileRemote.startsWith(request.path, '/windows/')) {
      return new MobileRemote.Pages.Windows(remote);
    } else if (MobileRemote.startsWith(request.path, '/current/')) {
      return new MobileRemote.Pages.Current(remote);
    } else if (MobileRemote.startsWith(request.path, '/go/')) {
      return new MobileRemote.Pages.Go(remote);
    } else {
      return new MobileRemote.Pages.NotFound(remote);
    }
  }
  
  this.noBody = function() {
    if (this.noBodyHTML == null) {
      var page = new MobileRemote.Pages.NoBody(remote);
      this.noBodyHTML = page.getBody();
    }
    
    return this.noBodyHTML;
  }
  
  var withLayout = function(body) {
    if (this.layoutTop == null)
      this.layoutTop = remote.env.fileContent('/views/layout/top.html');
    
    if (this.layoutBottom == null)
      this.layoutBottom = remote.env.fileContent('/views/layout/bottom.html');
    
    return this.layoutTop + body + this.layoutBottom;
  }
  
}