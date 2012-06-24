class Settings
  Remifi.Pages.Settings = Settings
  
  constructor: (@remote) ->
    
  render: (request, response) =>
    if request.path == '/settings/index.html' || request.path == '/settings/'
      @index(request, response)
      
    else if request.path == '/settings/about.html'
      @about(request, response)
      
    else if request.path == '/settings/update.html'
      @update(request, response)
      
    else if request.path == '/settings/getUpdate.html'
      @getUpdate(request, response)
      
    else if request.path == '/settings/fullscreen.html'
      @fullscreen(request, response)
      
    else if request.path == '/settings/xbmc.html'
      @xbmc(request, response)
      
  index: (request, response) =>
    @remote.views (v) =>
      v.page 'settings', =>
        v.toolbar()
        v.title("Settings")
        v.list [
          {
            title: "Bookmarks",
            url: "/bookmarklets/"
          },
          {
            title: "About Me",
            url: "/settings/about.html"
          }
        ], striped: true

        v.toggle 'Fullscreen Mode', '/settings/fullscreen.html', window.fullScreen
        v.toggle 'Using XBMC', '/settings/xbmc.html', @remote.isXBMC
        v.button('Check for Updates', '/settings/update.html', {type: 'primary'})

  fullscreen: (request, response) =>
    window.fullScreen = !window.fullScreen
    
    Application.prefs.setValue('extensions.remifi.autoFullscreenOff', !window.fullScreen)
    
    @index(request, response)

  xbmc: (request, response) =>
    @remote.isXBMC = !@remote.isXBMC
    Application.prefs.setValue('extensions.remifi.xbmc', @remote.isXBMC)
    @index(request, response)

  update: (request, response) =>
    self = this
    remote = @remote
    @remote.views (v) ->
      v.page 'update', ->
        v.toolbar()
        v.title("System Update")

        request = new XMLHttpRequest()
        request.open('GET', remote.xpiVersionPath, false)
        request.send(null)

        if request.status != 200
          v.error("Could not talk to the update server. Please try again later")

        else if request.responseText == remote.version
          v.info("You have the most up-to-date version of the mobile remote")

        else
          remote.newVersionAvailable(request.responseText, 'check')
          
          v.info("There is an updated version of remifi. Use the mouse to install the new version and restart.")
          v.br()
          v.button "Upgrade Remifi", "/settings/getUpdate.html", type: "primary"

        v.br()
        v.button("Back to Settings", '/settings/index.html')
  
  getUpdate: (request, response) =>
    @remote.currentBrowser().contentDocument.location.href = @remote.xpiPath
    @remote.pages.mouse.index(request, response);
  
  about: (request, response) =>
    @remote.views (v) ->
      v.page 'about_me', ->
        v.toolbar()
        v.title("About Me")

        v.list [
          {
            title: "Home: remifi.com",
            url: "http://www.remifi.com"
          },
          {
            title: "Created By Dan Cunning",
            url: "http://www.topdan.com",
            mobile: true
          },
          {
            title: "Follow @itopdan",
            url: "http://www.twitter.com/itopdan",
            mobile: true
          },
          {
            title: "Version: 0.1",
            url: '/settings/update.html'
          }
        ], striped: true
        
        v.br()
        v.button "Back to Settings", '/settings/index.html'
        v.br()
        
        v.title "Other Credits"
        v.list [
          {
            title: "jQtouch",
            url: "http://www.jqtouch.com/",
            mobile: true
          },
          {
            title: "Plain Old Webserver",
            url: "http://groups.google.com/group/firefoxpow",
            mobile: true
          },
          {
            title: "Crystal Clear",
            url: "http://www.everaldo.com/crystal/",
            mobile: true
          },
          {
            title: "borncold",
            url: "http://borncold.deviantart.com/",
            mobile: true
          }
          {
            title: "Website image and content rights reserved to website owner"
          },
        ]
        
