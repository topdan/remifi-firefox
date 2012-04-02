if (MobileRemote.Pages == null) MobileRemote.Pages = {}

MobileRemote.Pages.NotFound = function(remote) {
  
  this.getBody = function(request, response) {
    return remote.views(function(v) {
      // TODO actually go back
      
      v.page('not_found', function() {
        v.toolbar('Not Found', {left: {title: 'back', url: '/'}});

        v.error("Sorry, that page was not found.");
      })
    });
  }
  
};
