class LocalHost
  Remifi.Site.LocalHost = LocalHost
  
  constructor: (@remote) ->
  
  render: (uri, request, response) =>
    if uri.path == '/getting-started/'
      @gettingStarted(uri, request, response)
  
  gettingStarted: (uri, request, response) =>
    @remote.views (v) ->
      v.page 'firefox-session-restore', ->
        v.toolbar()
        
        v.br()
        v.info "You are connected to your TV through your mobile device!"
        v.br()
        v.button "Set up Bookmarks", "http://www.remifi.com/videos/how-to-setup-iphone-bookmarks.html", type: 'primary'
        v.br()
        v.button 'Start Browsing!', '/home.html'
        v.br()
        v.important "Or click the home button in the very upper right"