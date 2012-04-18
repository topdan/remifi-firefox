if (MobileRemote.Pages == null) MobileRemote.Pages = {}

MobileRemote.Pages.Settings = function(remote) {
  var self = this;
  
  this.version = remote.env.fileContent('/content/VERSION');
  this.xpiPath = "http://mobile-remote.topdan.com.s3.amazonaws.com/mobile-remote-edge.xpi";
  
  this.render = function(request, response) {
    if (request.path == '/settings/index.html' || request.path == '/settings/') {
      return this.index(request, response);
      
    } else if (request.path == '/settings/about.html') {
      return this.about(request, response);
      
    } else if (request.path == '/settings/update.html') {
      return this.update(request, response);
      
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
        
        v.button('Check for Updates', '/settings/update.html');
        
        if (window.fullScreen)
          v.button('Turn fullscreen off', '/settings/fullscreen.html')
        else
          v.button('Turn fullscreen on', '/settings/fullscreen.html')
      });
    });
  }
  
  this.update = function(request, response) {
    return remote.views(function(v) {
      v.page('update', function() {
        v.toolbar();
        v.title("System Update");
        
        var request = new XMLHttpRequest();
        request.open('GET', 'http://mobile-remote.topdan.com/EDGE-VERSION', false);
        request.send(null);

        if (request.status != 200) {
          
        } else if (request.responseText == remote.version) {
          v.info("You have the most up-to-date version of the mobile remote");
          v.br();
          v.button("Back to Settings", '/settings/index.html', {type: 'primary'});
          
        } else {
          v.info("There is an updated version of the mobile remote. Use the mouse app to agree to install the new version when the download is finished.");
          v.br();
          v.button("Get the Update", '/controls/visit.html?url=' + encodeURIComponent(self.xpiPath), {type: "primary"})
        }
        
      })
    })
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