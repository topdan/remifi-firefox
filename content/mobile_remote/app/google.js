MobileRemote.App.Google = function(remote) {
  
  this.name = "Google";
  this.domain = "www.google.com";
  this.domains = [this.domain];
  
  this.recognize = function(uri, request, response) {
    if (uri.path == '/') {
      
      if (request.path == '/apps/google/search.html') {
        return this.doSearch;
      } else {
        return this.index;
      }
      
    } else if (uri.path == '/search') {
      return this.search;
    }
  }
  
  this.index = function(request, response) {
    return remote.views(function(v) {
      v.page('google', function() {
        v.toolbar("Google");
        v.br();
        v.br();
        v.form('/apps/google/search.html', function(f) {
          
          f.fieldset(function() {
            f.search('q', {placeholder: 'Google Search'});
          })
          f.br();
          f.submit('Google Search', {type: 'info'});
          f.br();
          f.submit("I'm Feeling Lucky")
        })
      });
    });
  }
  
  this.doSearch = function(request, response) {
    // fill in text field
    
    // press 
  }
  
  this.search = function(request, response) {
    
  }
  
}
