if (MobileRemote.Pages == null) MobileRemote.Pages = {}

MobileRemote.Pages.Controls = function(remote) {
  
  this.getBody = function(request, response) {
    return remote.views(function(v) {
      // TODO actually go back
      
      v.page('controls', function() {
        v.toolbar('Controls', {right: {title: 'home', url: '/'}});

        v.error("Sorry, not implemented yet.");
      })
    });
  }
  
};
