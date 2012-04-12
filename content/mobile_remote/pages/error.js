if (MobileRemote.Pages == null) MobileRemote.Pages = {}

MobileRemote.Pages.Error = function(remote) {
  
  this.render = function(err, request, response) {
    return remote.views(function(v) {
      if (request.isScript) {
        v.safeOut('mobileRemote.error("' + v.escape(err) + '")');
      } else {
        v.page('internal_error', function() {
          v.toolbar();
          v.title("Error");
          
          v.out.push('<p class="error-message">I had trouble understanding this page. <a href="#" class="show-internal-error">Show details</a></p>');
          v.out.push('<p class="error-message internal-error-details" style="display:none">' + err + '</p>');
          
          v.br();
          v.br();
          v.button('Use Mouse App', '/mouse/index.html', {type: 'primary'})
        })
      }
    });
  }
  
};
