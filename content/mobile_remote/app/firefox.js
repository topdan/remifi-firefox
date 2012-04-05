MobileRemote.App.Firefox = function(remote) {
  
  this.recognize = function(uri) {
    if (uri.toString() == "about:sessionrestore") {
      return this.sessionRestore;
    } else if (uri.toString() == "about:blank") {
      return remote.pages.home.index;
    }
  }
  
  this.sessionRestore = function(request, response) {
    return remote.views(function(v) {
      v.page('firefox-session-restore', function() {
        v.toolbar("Restore");
      });
    });
  }
  
}
