if (MobileRemote.Pages == null) MobileRemote.Pages = {}

MobileRemote.Pages.NoBody = function(remote) {
  
  this.getBody = function() {
    return remote.views(function(v) {
      v.page('no_body', function() {
        v.toolbar('No Body', {right: {title: 'home', url: '/'}});
        
        v.error("Internal Error: That page didn't contain anything.");
      })
    });
  }
  
};
