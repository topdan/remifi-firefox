if (MobileRemote.Pages == null) MobileRemote.Pages = {}

MobileRemote.Pages.Error = function(remote) {
  
  this.getBody = function(err, request, response) {
    if (request.isScript) {
      return 'mobileRemote.error("' + err + '")';
      
    } else {
      return remote.views(function(v) {
        v.page('no_body', function() {
          v.toolbar('Error', {right: {title: 'home', url: '/'}});
          
          v.error("You encountered an internal Error");
          v.error(err);
        })
      });
    }
  }
  
};
