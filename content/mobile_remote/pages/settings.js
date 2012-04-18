if (MobileRemote.Pages == null) MobileRemote.Pages = {}

MobileRemote.Pages.Settings = function(remote) {
  
  this.render = function(request, response) {
    if (request.path == '/settings/index.html' || request.path == '/settings/') {
      return this.index(request, response);
      
    } else if (request.path == '/settings/about.html') {
      return this.about(request, response);
      
    } else if (request.path == '/settings/fullscreen.html') {
      return this.fullscreen(request, response);
    }
  }
  
  this.fullscreen = function(request, response) {
    window.fullScreen = !window.fullScreen;
    return this.index(request, response);
  }
  
  this.index = function(request, response) {
    return remote.views(function(v) {
      v.page('settings', function() {
        v.toolbar();
        v.title("Settings");
        v.list([
          {
            title: "Bookmarklets",
            url: "/bookmarklets/"
          },
          {
            title: "About Me",
            url: "/settings/about.html"
          }
        ])
        
        if (window.fullScreen)
          v.button('Turn fullscreen off', '/settings/fullscreen.html')
        else
          v.button('Turn fullscreen on', '/settings/fullscreen.html')
      });
    });
  }
  
  this.about = function(request, response) {
    return remote.views(function(v) {
      v.page('about_me', function() {
        v.toolbar();
        v.title("About Me");
        
        v.list([
          {
            title: "Created By Dan Cunning"
          },
          {
            title: "Follow @itopdan",
            url: "http://www.twitter.com/itopdan"
          },
          {
            title: "Version: 0.1"
          }
        ])
      });
    });
  }
  
}