if (MobileRemote.Pages == null) MobileRemote.Pages = {}

MobileRemote.Pages.Home = function(remote) {
  
  this.render = function(request, response) {
    return this.index(request, response);
  }
  
  this.index = function(request, response) {
    return remote.views(function(v) {
      
      v.page('home', function() {
        v.toolbar('Home', {left: {title: 'nav', url: '#nav'}, right: {title: 'back', url: '/'}});
        
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
          null,
          {
            title: "tabs",
            url: "/tabs/index.html"
          }
        ]);
        
      })
      
    });
  };
  
};
