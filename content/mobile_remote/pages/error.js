if (MobileRemote.Pages == null) MobileRemote.Pages = {}

MobileRemote.Pages.Error = function(remote) {
  
  this.render = function(err, request, response) {
    return remote.views(function(v) {
      if (request.isScript) {
        v.safeOut('mobileRemote.error("' + v.escape(err) + '")');
      } else {
        v.page('no_body', function() {
          v.toolbar('Error');
          
          v.error("You encountered an internal Error");
          v.error(err);
        })
      }
    });
  }
  
};
