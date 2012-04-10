if (MobileRemote.Pages == null) MobileRemote.Pages = {}

MobileRemote.Pages.NotFound = function(remote) {
  
  this.render = function(request, response) {
    return remote.views(function(v) {
      // TODO actually go back
      
      v.page('not_found', function() {
        v.toolbar();

        v.error("Sorry, that page was not found.");
      })
    });
  }
  
};
