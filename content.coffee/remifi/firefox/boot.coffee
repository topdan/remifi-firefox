class Boot
  Remifi.Firefox.Boot = Boot
  
  constructor: () ->
    
  load: () =>
    unless @refreshWindow()
      @loadRemote()
      @checkForUpdates()
      @loadPageListener()
      @installToolbarButton()
      @tryFirstSplashPage()
  
  unload: () ->
    if Remifi.instance && Remifi.isReference != true
      Remifi.instance.unload()
      Remifi.instance = null

  loadRemote: () =>
    env = new Remifi.Firefox.Env()
    @remote = new Remifi.Base(env)
    @remote.port = @port()
    @remote.view = new Remifi.Firefox.View()
    @remote.static = new Remifi.Static(@remote, '/content/static.json')
    
    @loadServer()

    Remifi.instance = @remote
    @remote.load()

  loadPageListener: () =>
    # https://developer.mozilla.org/en/Code_snippets/On_page_load
    appcontent = document.getElementById("appcontent")
    if appcontent
      pageLoad = (e) =>
        e.originalTarget.remifiIsLoaded = true
      
      appcontent.addEventListener("DOMContentLoaded", pageLoad, true)

      progressListener = {}
      stateStart = Components.interfaces.nsIWebProgressListener.STATE_START
      stateStop = Components.interfaces.nsIWebProgressListener.STATE_STOP
      progressListener.onStateChange = (aWebProgress, aRequest, aFlag, aStatus) =>
        if aFlag & stateStart
          @remote.currentDocument().remifiIsLoaded = null
        else if aFlag & stateStart
          @remote.currentDocument().remifiIsLoaded = true
      
      gBrowser.addProgressListener progressListener
      
  checkForUpdates: () =>
    return if @remote.env.isDevMode
    
    request = new XMLHttpRequest()
    request.open('GET', 'http://files.remifi.com/firefox/EDGE-VERSION', true)
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
      if win.Remifi.instance
        Remifi.instance = win.Remifi.instance
        Remifi.isReference = true
        Remifi.instance.refresh()
        return true
    false
  
  tryFirstSplashPage: () =>
    firstSplash = "extensions.remifi.firstSplash"
    return if Application.prefs.getValue(firstSplash, false)
    
    # won't work on the onLoad thread, not sure what event to hook into so just wait a bit
    setTimeout =>
      Application.prefs.setValue(firstSplash, true)
      gBrowser.selectedTab = gBrowser.addTab "http://localhost:#{@remote.port}/getting-started/"
    , 1000
  
  installToolbarButton: () =>
    firstRunPref = "extensions.remifi.toolbarButtonAdded";
    unless Application.prefs.getValue(firstRunPref, false)
      Application.prefs.setValue(firstRunPref, true)
      @remote.view.installButton 'nav-bar', 'remifi-button', 'home-button'
      @remote.refresh()
  
  port: () =>
    Application.prefs.getValue('extensions.remifi.port', 6670)
  
  loadServer: () =>
    @remote.server = new Remifi.Firefox.Server(@remote.port)
    @remote.server.dynamicRequest = @remote.handleRequest
    @remote.server.getStaticFilePath = (request, response) =>
      fullpath = request.fullpath
      if Remifi.startsWith(fullpath, '/static/')
        pos = fullpath.lastIndexOf("?")
        unless pos == -1
          fullpath = fullpath.substring(0, pos)
          response.headers['Expires'] = "Thu, 31 Dec 2037 23:55:55 GMT" unless @remote.env.isDevMode
        @remote.env.extensionPath + fullpath
    
  