class LocalHost
  Remifi.App.LocalHost = LocalHost
  
  constructor: (@remote) ->
  
  render: (uri, request, response) =>
    if uri.path == '/getting-started/'
      @gettingStarted(uri, request, response)
  
  gettingStarted: (uri, request, response) =>
    @remote.views (v) ->
      v.page 'firefox-session-restore', ->
        v.toolbar()
        
        v.title "You are connected to your TV through your mobile device!"
        v.br()
        v.important "Now click the home button in the very upper right to start browsing the web"