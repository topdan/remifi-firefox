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
            title: "google",
            url: "google.html"
          },
          {
            title: "current",
            url: "current.html"
          },
          {
            title: "windows",
            url: "windows.html"
          },
          {
            title: "tabs",
            url: "tabs.html"
          }
        ]);
        
      })
      
    });
  };
  
};
