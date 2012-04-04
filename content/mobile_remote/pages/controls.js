if (MobileRemote.Pages == null) MobileRemote.Pages = {}

MobileRemote.Pages.Controls = function(remote) {
  
  this.getBody = function(request, response) {
    if (request.path == '/controls/index.html' || request.path == '/controls/' || request.path == '/controls/mouse.html') {
      return this.mouse(request, response);
      
    } else if (request.path == '/controls/links.html') {
      return this.links(request, response);
      
    } else if (request.path == '/controls/home.html') {
      return this.home(request, response);
      
    } else if (request.path == '/controls/stop.html') {
      return this.stop(request, response);
      
    } else if (request.path == '/controls/back.html') {
      return this.back(request, response);
      
    } else if (request.path == '/controls/forward.html') {
      return this.forward(request, response);
      
    }
  }
  
  this.home = function(request, response) {
    remote.currentBrowser().goHome();
    return this.mouse(request, response);
  }
  
  this.stop = function(request, response) {
    remote.currentBrowser().stop();
    return this.mouse(request, response);
  }
  
  this.back = function(request, response) {
    remote.currentBrowser().goBack();
    return this.mouse(request, response);
  }
  
  this.forward = function(request, response) {
    remote.currentBrowser().goForward();
    return this.mouse(request, response);
  }
  
  this.mouse = function(request, response) {
    return remote.views(function(v) {
      v.page('controls', function() {
        v.toolbar('Controls', {right: {title: 'home', url: '/'}});
        
        var back = remote.currentBrowser().canGoBack ? {title: 'back', url: '/controls/back.html'} : null;
        var forward = remote.currentBrowser().canGoForward ? {title: 'forward', url: '/controls/forward.html'} : null;
        var home = {title: 'home', url: '/controls/home.html'};
        var stop = {title: 'stop', url: '/controls/stop.html'};
        
        v.systemApps([back, home, stop, forward]);
      });
    });
  };
  
};
