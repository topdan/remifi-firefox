if (MobileRemote.Pages == null) MobileRemote.Pages = {}

MobileRemote.Pages.Home = function(remote) {
  
  this.getBody = function(request, response) {
    return remote.views(function(v) {
      
      v.page('home', function() {
        v.toolbar('Home');
        
        v.apps([
          {
            title: "bookmarks",
            url: "bookmarks.html"
          },
          {
            title: "history",
            url: "history.html"
          }
        ]);
        
        v.systemApps([
          {
            title: "mouse",
            url: "/mouse/index.html"
          },
          null,
          {
            title: "tabs",
            url: "/tabs/index.html"
          },
          {
            title: "go",
            url: "/go/index.html"
          }
        ]);
        
      })
      
    });
  };
  
};
