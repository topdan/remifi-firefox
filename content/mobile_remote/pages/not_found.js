if (MobileRemote.Pages == null) MobileRemote.Pages = {}

MobileRemote.Pages.NotFound = function(remote) {
  
  this.html = null;
  
  this.getBody = function(request, response) {
    if (this.html == null)
      this.html = remote.env.fileContent('/views/404.html');
    
    return this.html;
  }
  
};
