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
          }
        ]);
        
        v.systemApps([
          {
            title: "bookmarklet",
            url: "bookmarklets/index.html"
          },
          null,
          {
            title: "keyboard",
            url: "/keyboard/index.html",
            icon: {url: '/static/images/keyboard.png'}
          },
          {
            title: "mouse",
            url: "/mouse/index.html",
            icon: {url: '/static/images/mouse.png'}
          }
        ])
        
        v.safeOut('<div class="info"><p>Add this page to your home screen for easier access.</p></div>')
      })
      
    });
  };
  
};
