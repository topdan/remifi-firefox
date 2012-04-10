MobileRemote.App.About = function(remote) {
  
  this.render = function(uri, request, response) {
    if (uri.toString() == "about:sessionrestore") {
      
      if (request.path == "/apps/about/sessionrestore/start-new-session.html") {
        return sessionRestoreStartNewSession(request, response);
        
      } else if (request.path == "/apps/about/sessionrestore/restore.html") {
        return sessionRestoreRestore(request, response);
        
      } else {
        return this.sessionRestore(request, response);
      }
      
    } else if (uri.toString() == "about:blank") {
      return remote.pages.home.index(request, response);
      
    }
  }
  
  this.sessionRestore = function(request, response) {
    return remote.views(function(v) {
      v.page('firefox-session-restore', function() {
        v.toolbar();
        v.br();
        v.br();
        v.button("Start New Session", '/apps/about/sessionrestore/start-new-session.html', {type: 'primary'});
        v.br();
        v.button("Restore", '/apps/about/sessionrestore/restore.html');
      });
    });
  }
  
  var sessionRestoreStartNewSession = function(request, response) {
    // Security Note: run in sandbox because running a page function
    // But since we're checking about that the URI is about:, it's served locally
    // by firefox and is pretty safe
    var s = Components.utils.Sandbox(content);
    s.win = content;
    Components.utils.evalInSandbox("win.startNewSession();", s);
    
    return remote.pages.controls.wait('/', request, response);
  }
  
  var sessionRestoreRestore = function(request, response) {
    // Security Note: run in sandbox because running a page function
    // But since we're checking about that the URI is about:, it's served locally
    // by firefox and is pretty safe
    var s = Components.utils.Sandbox(content);
    s.win = content;
    Components.utils.evalInSandbox("win.restoreSession();", s);
    
    return remote.pages.controls.wait('/', request, response);
  }
  
}
