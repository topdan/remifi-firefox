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
      @xbmcStartup() if @remote.isXBMC
  
  unload: () ->
    if Remifi.instance && Remifi.isReference != true
      Remifi.instance.unload()
      Remifi.instance = null

  loadRemote: () =>
    env = new Remifi.Firefox.Env()
    @remote = new Remifi.Base(env)
    @remote.port = @port()
    @remote.view = new Remifi.Firefox.View(@remote)
    @remote.static = new Remifi.Static(@remote, '/content/static.json')
    if @remote.env.isWindows
      @remote.input = new Remifi.Firefox.Input.Win32()
    else if @remote.env.isLinux
      @remote.input = new Remifi.Firefox.Input.X11(@remote)
    else
      @remote.input = new Remifi.Firefox.Input.OSX()
    
    @loadServer()

    Remifi.instance = @remote
    @remote.load() if Application.prefs.getValue(@remote.onSetting, true)

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
        else if aFlag & stateStop
          @remote.currentDocument().remifiIsLoaded = true
      
      gBrowser.addProgressListener progressListener
      
  checkForUpdates: () =>
    return if @remote.env.isDevMode
    
    request = new XMLHttpRequest()
    request.open('GET', @remote.xpiVersionPath, true)
    request.onreadystatechange = (e) =>
      if request.readyState != 4
        # keep waiting
        
      else if request.status != 200
        Components.utils.reportError "Checking for updates failed: #{request.status}"
        
      else if request.responseText == @remote.version
        # great, no updates
        
      else
        @remote.newVersionAvailable(request.responseText, 'alert')
    
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
    return if Application.prefs.getValue(firstSplash, false) || !@remote.isRunning()
    
    # won't work on the onLoad thread, not sure what event to hook into so just wait a bit
    setTimeout =>
      Application.prefs.setValue(firstSplash, true)
      @remote.view.openSplashPage()
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
        path = @remote.env.extensionPath + fullpath
        @remote.env.polishPath(path)
  
  xbmcStartup: () =>
    setTimeout =>
      x = Application.prefs.getValue('extensions.remifi.xbmc.x', 25)
      y = Application.prefs.getValue('extensions.remifi.xbmc.y', 100)
      
      window.fullScreen = true
      @remote.pages.mouse.actualMouseAction('click', x, y, hide: true) if x && y
    , 1000
