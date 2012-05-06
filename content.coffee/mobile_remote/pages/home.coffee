class Home
  Remifi.Pages.Home = Home
  
  constructor: (@remote) ->
  
  render: (request, response) =>
    @index(request, response);
  
  index: (request, response) =>
    @remote.views (v) =>
      v.page 'home', =>
        v.toolbar({back: true});

        if @remote.updateAvailable
          v.safeOut("<a href=\"#\" data-remote-url=\"#{@remote.xpiPath}\" class=\"info update-available\">We've released a new version. Click here to download it.</a>")
        else
          v.safeOut('<div class="info"><p>Add this page to your home screen for easier access.</p></div>')

        v.apps([
          {
            title: "settings",
            url: "/settings/index.html",
            icon: {url: @remote.static.urlFor('/static/images/gears.png')}
          },
          {
            title: "youtube",
            url: "/controls/visit.html?url=http://www.youtube.com",
            icon: {url: @remote.static.urlFor('/static/images/youtube.png')}
          },
          {
            title: "hulu",
            url: "/controls/visit.html?url=http://www.hulu.com",
            icon: {url: @remote.static.urlFor('/static/images/hulu.png')}
          },
          {
            title: "netflix",
            url: "/controls/visit.html?url=http://www.netflix.com",
            icon: {url: @remote.static.urlFor('/static/images/netflix.png')}
          },
          {
            title: "hbogo",
            url: "/controls/visit.html?url=http%3A%2F%2Fwww.hbogo.com%2F%23home%2F",
            icon: {url: @remote.static.urlFor('/static/images/hbogo.png')}
          },
          {
            title: "maxgo",
            url: "/controls/visit.html?url=http%3A%2F%2Fwww.maxgo.com%2F%23movies%2F",
            icon: {url: @remote.static.urlFor('/static/images/maxgo.jpg')}
          },
          {
            title: "reddit",
            url: "/controls/visit.html?url=http://www.reddit.com",
            icon: {url: @remote.static.urlFor('/static/images/reddit.png')}
          },
          {
            title: "south park",
            url: "/controls/visit.html?url=http://www.southparkstudios.com/full-episodes",
            icon: {url: @remote.static.urlFor('/static/images/southpark.png')}
          },
          {
            title: "ted",
            url: "/controls/visit.html?url=http://www.ted.com",
            icon: {url: @remote.static.urlFor('/static/images/ted.png')}
          },
          {
            title: "revision3",
            url: "/controls/visit.html?url=http://revision3.com",
            icon: {url: @remote.static.urlFor('/static/images/revision3.png')}
          },
          {
            title: "railscasts",
            url: "/controls/visit.html?url=http://railscasts.com",
            icon: {url: @remote.static.urlFor('/static/images/railscasts.png')}
          },
          {
            title: "vimeo",
            url: "/controls/visit.html?url=http://vimeo.com",
            icon: {url: @remote.static.urlFor('/static/images/vimeo.png')}
          },
          {
            title: "khan acad",
            url: "/controls/visit.html?url=http://www.khanacademy.com",
            icon: {url: @remote.static.urlFor('/static/images/khan-academy.png')}
          },
          {
            title: "pa tv",
            url: "/controls/visit.html?url=http://penny-arcade.com/patv",
            icon: {url: @remote.static.urlFor('/static/images/penny-arcade.png')}
          },
          {
            title: "my damn",
            url: "/controls/visit.html?url=http://www.mydamnchannel.com",
            icon: {url: @remote.static.urlFor('/static/images/my-damn-channel.png')}
          },
          {
            title: "grooveshark",
            url: "/controls/visit.html?url=http://grooveshark.com",
            icon: {url: @remote.static.urlFor('/static/images/grooveshark.png')}
          },
        ]);
