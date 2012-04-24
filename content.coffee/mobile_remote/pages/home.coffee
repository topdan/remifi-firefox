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
            title: "settings",
            url: "/settings/index.html",
            icon: {url: '/static/images/gears.png'}
          },
          {
            title: "hbogo",
            url: "/controls/visit.html?url=http%3A%2F%2Fwww.hbogo.com%2F%23home%2F",
            icon: {url: '/static/images/hbogo.png'}
          },
          {
            title: "maxgo",
            url: "/controls/visit.html?url=http%3A%2F%2Fwww.maxgo.com%2F%23movies%2F",
            icon: {url: '/static/images/maxgo.jpg'}
          },
          {
            title: "r/music",
            url: "/controls/visit.html?url=http://www.reddit.com/r/music/",
            icon: {url: '/static/images/reddit.png'}
          },
          {
            title: "r/NetflixBestOf",
            url: "/controls/visit.html?url=http://www.reddit.com/r/NetflixBestOf/",
            icon: {url: '/static/images/reddit.png'}
          },
          {
            title: "south park",
            url: "/controls/visit.html?url=http://www.southparkstudios.com/full-episodes",
            icon: {url: '/static/images/southpark.png'}
          },
          {
            title: "ted",
            url: "/controls/visit.html?url=http://www.ted.com",
            icon: {url: '/static/images/ted.png'}
          },
          {
            title: "revision3",
            url: "/controls/visit.html?url=http://revision3.com",
            icon: {url: '/static/images/revision3.png'}
          },
          {
            title: "railscasts",
            url: "/controls/visit.html?url=http://railscasts.com",
            icon: {url: '/static/images/railscasts.png'}
          },
          {
            title: "vimeo",
            url: "/controls/visit.html?url=http://vimeo.com",
            icon: {url: '/static/images/vimeo.png'}
          },
          {
            title: "khan acad",
            url: "/controls/visit.html?url=http://www.khanacademy.com",
            icon: {url: '/static/images/khan-academy.png'}
          },
        ]);

        v.safeOut('<div class="info"><p>Add this page to your home screen for easier access.</p></div>')
