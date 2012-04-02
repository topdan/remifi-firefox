if (MobileRemote.Pages == null) MobileRemote.Pages = {}

MobileRemote.Pages.Windows = function(remote) {
  
  this.getBody = function(request, response) {
    return remote.views(function(v) {
      
    });
  };
  
};
