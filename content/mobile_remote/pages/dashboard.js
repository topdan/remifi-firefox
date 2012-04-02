if (MobileRemote.Pages == null) MobileRemote.Pages = {}

MobileRemote.Pages.Dashboard = function(remote) {
  
  this.getBody = function(request, response) {
    return remote.views(function(v) {
      
      v.page('page1', function() {
        v.toolbar('Home');
        
        v.apps([
          {
            title: "Bookmarks",
            url: "bookmarks.html"
          },
          {
            title: "History",
            url: "history.html"
          }
        ]);
        
        v.systemApps([
          {
            title: "search",
            url: "/search/index.html"
          },
          {
            title: "current",
            url: "/current/index.html"
          },
          {
            title: "windows",
            url: "/windows/index.html"
          },
          {
            title: "tabs",
            url: "/tabs/index.html"
          }
        ]);
        
      })
      
    });
  };
  
};
