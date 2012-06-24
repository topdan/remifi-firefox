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
          v.safeOut("<a href=\"/settings/getUpdate.html\" class=\"info2 update-available\">We've released a new version. Click here to upgrade.</a>")
        else
          v.safeOut('<div class="info"><p>Add this page to your home screen for easier access.</p></div>')

        apps = [
          {
            title: "settings",
            url: "/settings/index.html",
            icon: {url: @remote.static.urlFor('/static/images/gears.png')},
            position: 0
          }
        ]
        
        if @remote.isXBMC
          apps[0].position = 1
          apps.push
            title: 'exit'
            url: '/controls/confirmExit.html'
            icon: {url: @remote.static.urlFor('/static/images/exit.png')}
            position: 0
        
        for site in @remote.pages.sites.all()
          title = site.metadata['home.title']
          pos = site.metadata['home.pos']
          url = site.metadata['home.url']
          img = site.metadata['home.img']
          
          if title && url && img && pos
            apps.push
              title: title
              url: "/controls/visit.html?url=#{encodeURIComponent(url)}"
              icon: {url: @remote.static.urlFor("/static/images/#{img}")}
              position: parseInt(pos)

        apps.sort (a, b) -> a.position - b.position
        v.apps(apps)
