if (MobileRemote.Pages == null) MobileRemote.Pages = {}

MobileRemote.Pages.NoBody = function(remote) {
  
  this.getBody = function(request, response) {
    if (request.isScript) {
      return "// no body";
    } else {
      return remote.views(function(v) {
        v.page('no_body', function() {
          v.toolbar('No Body', {right: {title: 'home', url: '/home.html'}});
          
          v.error("Internal Error: That page didn't contain anything.");
        })
      });
    }
  }
  
};
