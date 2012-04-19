class About
  MobileRemote.App.About = About
  
  constructor: (@remote) ->
  
  render: (uri, request, response) =>
    if uri.toString() == 'about:home'
      @remote.pages.home.index(request, response)
      
    else if uri.toString() == "about:sessionrestore"
      
      if request.path == "/apps/about/sessionrestore/start-new-session.html"
        @sessionRestoreStartNewSession(request, response)
        
      else if request.path == "/apps/about/sessionrestore/restore.html"
        @sessionRestoreRestore(request, response)
        
      else
        @sessionRestore(request, response)
      
    else if uri.toString() == "about:blank"
      @remote.pages.home.index(request, response)
  
  sessionRestore: (request, response) =>
    @remote.views (v) ->
      v.page 'firefox-session-restore', ->
        v.toolbar()
        v.br()
        v.br()
        v.button("Start New Session", '/apps/about/sessionrestore/start-new-session.html', {type: 'primary'})
        v.br()
        v.button("Restore", '/apps/about/sessionrestore/restore.html')
  
  sessionRestoreStartNewSession: (request, response) =>
    # Security Note: run in sandbox because running a page function
    # But since we're checking about that the URI is about:, it's served locally
    # by firefox and is pretty safe
    s = Components.utils.Sandbox(content)
    s.win = content
    Components.utils.evalInSandbox("if (win.startNewSession) win.startNewSession();", s)
    
    @remote.pages.controls.wait('/', request, response)
  
  sessionRestoreRestore: (request, response) =>
    # Security Note: run in sandbox because running a page function
    # But since we're checking about that the URI is about:, it's served locally
    # by firefox and is pretty safe
    s = Components.utils.Sandbox(content)
    s.win = content
    Components.utils.evalInSandbox("try { win.restoreSession(); } catch(err) { }", s)
    
    @remote.pages.controls.wait('/', request, response)
    