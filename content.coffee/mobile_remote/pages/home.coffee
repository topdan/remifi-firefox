class Home
  MobileRemote.Pages.Home = Home
  
  constructor: (@remote) ->
  
  render: (request, response) =>
    @index(request, response);
  
  index: (request, response) =>
    @remote.views (v) ->
      v.page 'home', ->
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
          },
          {
            title: "reddit/music",
            url: "/controls/visit.html?url=http://www.reddit.com/r/music/",
            icon: {url: '/static/images/reddit.png'}
          },
          {
            title: "reddit/netflix",
            url: "/controls/visit.html?url=http://www.reddit.com/r/netflix/",
            icon: {url: '/static/images/reddit.png'}
          },
          {
            title: "south park",
            url: "/controls/visit.html?url=http://www.southparkstudios.com",
            icon: {url: '/static/images/southpark.png'}
          }
        ]);

        v.systemApps([
          {
            title: "settings",
            url: "/settings/index.html",
            icon: {url: '/static/images/gears.png'}
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
