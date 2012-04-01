MobileRemote.Controller = function(remote, request, response) {
  
  this.layoutTop = null;
  this.layoutBottom = null;
  this.notFoundBodyHTML = null;
  
  this.process = function() {
    var route = this.findRoute();
    var body = route.getBody(request, response);
    
    if (request.isXhr) {
      return body;
    } else {
      return withLayout(body);
    }
  }
  
  this.findRoute = function() {
    if (request.path == "/") {
      return new MobileRemote.Pages.Dashboard(remote);
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