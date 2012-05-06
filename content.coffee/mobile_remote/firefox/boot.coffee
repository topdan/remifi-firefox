class Boot
  MobileRemote.Firefox.Boot = Boot
  
  constructor: () ->
    
  load: () =>
    unless @refreshWindow()
      @loadRemote()
      @checkForUpdates()
      @loadPageListener()
      @tryFirstSplashPage()
  
  unload: () ->
    if MobileRemote.instance && MobileRemote.isReference != true
      MobileRemote.instance.unload()
      MobileRemote.instance = null

  loadRemote: () =>
    env = new MobileRemote.Firefox.Env()
    @remote = new MobileRemote.Base(env)
    @remote.port = @port()
    @remote.view = new MobileRemote.Firefox.View()
    @remote.static = new MobileRemote.Static(@remote, '/content/static.json')
    
    @loadServer()

    MobileRemote.instance = @remote
    @remote.load()

    @tryFirstSplashPage()

  loadPageListener: () =>
    # https://developer.mozilla.org/en/Code_snippets/On_page_load
    appcontent = document.getElementById("appcontent")
    if appcontent
      pageLoad = (e) =>
        e.originalTarget.remifiIsLoaded = true
      
      appcontent.addEventListener("DOMContentLoaded", pageLoad, true)

      progressListener = {}
      stateStart = Components.interfaces.nsIWebProgressListener.STATE_START
      progressListener.onStateChange = (aWebProgress, aRequest, aFlag, aStatus) =>
        if aFlag & stateStart
          @remote.currentDocument().remifiIsLoaded = null
      
      gBrowser.addProgressListener progressListener
      
  checkForUpdates: () =>
    return if @remote.env.isDevMode
    
    request = new XMLHttpRequest()
    request.open('GET', 'http://mobile-remote.topdan.com/EDGE-VERSION', true)
    request.onreadystatechange = (e) =>
      if request.readyState != 4
        # keep waiting
        
      else if request.status != 200
        Components.utils.reportError "Checking for updates failed: #{request.status}"
        
      else if request.responseText == @remote.version
        # great, no updates
        
      else
        @remote.updateAvailable = true
    
    request.send(null)

  # check for the server already running inside another window and copy its reference
  refreshWindow: () =>
    wm = Components.classes["@mozilla.org/appshell/window-mediator;1"].getService(Components.interfaces.nsIWindowMediator)
    wenum = wm.getEnumerator(null)
    loop
      break unless wenum.hasMoreElements()

      win = wenum.getNext()
      if win.MobileRemote.instance
        MobileRemote.instance = win.MobileRemote.instance
        MobileRemote.isReference = true
        MobileRemote.instance.refresh()
        return true
    false
  
  tryFirstSplashPage: () =>
    firstSplash = "extensions.mobile-remote.firstSplash"
    return if Application.prefs.getValue(firstSplash, false)
    
    # won't work on the onLoad thread, not sure what event to hook into so just wait a bit
    setTimeout ->
      Application.prefs.setValue(firstSplash, true)
      gBrowser.selectedTab = gBrowser.addTab "http://localhost:#{@remote.port}/getting-started/"
    , 1000
  
  port: () =>
    Application.prefs.getValue('extensions.mobile-remote.port', 6670)
  
  loadServer: () =>
    @remote.server = new MobileRemote.Firefox.Server(@remote.port)
    @remote.server.dynamicRequest = @remote.handleRequest
    @remote.server.getStaticFilePath = (request, response) =>
      fullpath = request.fullpath
      if MobileRemote.startsWith(fullpath, '/static/')
        pos = fullpath.lastIndexOf("?")
        unless pos == -1
          fullpath = fullpath.substring(0, pos)
          response.headers['Expires'] = "Thu, 31 Dec 2037 23:55:55 GMT" unless @remote.env.isDevMode
        @remote.env.extensionPath + fullpath
    
  