MobileRemote.Controller = function(remote, request, response) {
  
  this.layoutTop = null;
  this.layoutBottom = null;
  this.notFoundBodyHTML = null;
  
  this.process = function() {
    var route = this.findRoute();
    var body = route.getBody(request, response);
    
    if (body == undefined)
      body = "";
    
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
    } else if (MobileRemote.startsWith(request.path, '/search/')) {
      return new MobileRemote.Pages.Search(remote);
    } else {
      return new MobileRemote.Pages.NotFound(remote);
    }
  }
  
  var withLayout = function(body) {
    if (this.layoutTop == null)
      this.layoutTop = remote.env.fileContent('/views/layout/top.html');
    
    if (this.layoutBottom == null)
      this.layoutBottom = remote.env.fileContent('/views/layout/bottom.html');
    
    return this.layoutTop + body + this.layoutBottom;
  }
  
  var notFoundBody = function() {
    if (this.notFoundBodyHTML == null) {
      this.notFoundBodyHTML = remote.env.fileContent('/views/404.html');
    }
    
    return notFoundBodyHTML;
  }
  
}