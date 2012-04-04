if (MobileRemote.Pages == null) MobileRemote.Pages = {}

MobileRemote.Pages.Error = function(remote) {
  
  this.getBody = function(err, request, response) {
    return remote.views(function(v) {
      if (request.isScript) {
        v.content.push('mobileRemote.error("' + v.escape(err) + '")');
      } else {
        v.page('no_body', function() {
          v.toolbar('Error', {right: {title: 'home', url: '/'}});
          
          v.error("You encountered an internal Error");
          v.error(err);
        })
      }
    });
  }
  
};
