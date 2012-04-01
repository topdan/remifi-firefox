MobileRemote.Controller = function(remote, request, response) {
  
  this.layoutTop = null;
  this.layoutBottom = null;
  
  this.process = function() {
    var body = "<h2>HI!</h2>"
    
    if (request.isXhr) {
      return body;
    } else {
      return withLayout(body);
    }
  }
  
  var withLayout = function(body) {
    if (this.layoutTop == null)
      this.layoutTop = remote.env.fileContent('/views/layout/top.html');
    
    if (this.layoutBottom == null)
      this.layoutBottom = remote.env.fileContent('/views/layout/bottom.html');
    
    return this.layoutTop + body + this.layoutBottom;
  }
  
}