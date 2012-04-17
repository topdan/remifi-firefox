if (MobileRemote.Pages == null) MobileRemote.Pages = {}

MobileRemote.Pages.Home = function(remote) {
  
  this.render = function(request, response) {
    return this.index(request, response);
  }
  
  this.index = function(request, response) {
    return remote.views(function(v) {
      
      v.page('home', function() {
        v.toolbar({back: true});
        
        v.apps([
          {
            title: "bookmarklet",
            url: "bookmarklets/index.html"
          },
          {
            title: "bookmarks",
            url: "bookmarks.html"
          },
          {
            title: "history",
            url: "history.html"
          },
          {
            title: "tabs",
            url: "/tabs/index.html"
          },
          {
            title: "windows",
            url: "/windows/index.html"
          },
          {
            title: "keyboard",
            url: "/keyboard/index.html"
          },
          {
            title: "mouse",
            url: "/mouse/index.html"
          },
          {
            title: "youtube",
            url: "/controls/visit.html?url=http://www.youtube.com",
            icon: {url: '/static/images/youtube.png'}
          },
          {
            title: "hulu",
            url: "/controls/visit.html?url=http://www.hulu.com",
            icon: {url: '/static/images/hulu.png'}
          },
          {
            title: "netflix",
            url: "/controls/visit.html?url=http://www.netflix.com",
            icon: {url: '/static/images/netflix.png'}
          },
          {
            title: "hbogo",
            url: "/controls/visit.html?url=http%3A%2F%2Fwww.hbogo.com%2F%23home%2F",
            icon: {url: '/static/images/hbogo.png'}
          },
          {
            title: "maxgo",
            url: "/controls/visit.html?url=http%3A%2F%2Fwww.maxgo.com%2F%23home%2F",
            icon: {url: '/static/images/maxgo.jpg'}
          },
        ]);
      })
      
    });
  };
  
};
