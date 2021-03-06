class Base
  Remifi.Base = Base
  
  constructor: (@env) ->
    @view = null
    
    @version = @env.fileContent('/content/VERSION')
    
    @filePath = Application.prefs.getValue("extensions.remifi.xpiPath", "http://files.remifi.com/firefox/edge")
    @xpiPath = "#{@filePath}.xpi"
    @xpiVersionPath = "#{@filePath}.version?#{@version}"
    
    @onSetting = "extensions.remifi.onByDefault"
    
    @isXBMC = Application.prefs.getValue('extensions.remifi.xbmc', false)
    
    @pages = {}
    @pages.sites      = new Remifi.Pages.Sites(@)
    @pages.home      = new Remifi.Pages.Home(@)
    @pages.tabs      = new Remifi.Pages.Tabs(@)
    @pages.windows   = new Remifi.Pages.Windows(@)
    @pages.controls  = new Remifi.Pages.Controls(@)
    @pages.keyboard  = new Remifi.Pages.Keyboard(@)
    @pages.mouse     = new Remifi.Pages.Mouse(@)
    @pages.error     = new Remifi.Pages.Error(@)
    @pages.notFound  = new Remifi.Pages.NotFound(@)
    @pages.noBody    = new Remifi.Pages.NoBody(@)
    @pages.settings  = new Remifi.Pages.Settings(@)
    @pages.bookmarklets = new Remifi.Pages.Bookmarklets(@)
    @pages.gettingStarted = new Remifi.Pages.GettingStarted(@)
  
  currentURL: =>
    @currentDocument().location.href
  
  currentWindow: =>
    wm = Components.classes["@mozilla.org/appshell/window-mediator;1"].getService(Components.interfaces.nsIWindowMediator)
    wm.getMostRecentWindow("navigator:browser")
  
  currentBrowser: =>
    @currentWindow().getBrowser()
  
  currentDocument: =>
    @currentBrowser().contentDocument
  
  createSandbox: (url, options) =>
    options = {} if (options == null)
    
    sandbox = Components.utils.Sandbox(content)
    
    if options.zepto
      sandbox.window = @currentBrowser().contentWindow
      sandbox.document = @currentBrowser().contentDocument
      
      browserX = window.mozInnerScreenX
      browserY = window.mozInnerScreenY
      unless window.fullScreen
        browserY += document.getElementById("navigator-toolbox").clientHeight
      
      zepto = @env.fileContent('/sites/lib/zepto.js')
      Components.utils.evalInSandbox('navigator = {userAgent: "Mozilla/5.0 (Macintosh Intel Mac OS X 10.5 rv:11.0) Gecko/20100101 Firefox/11.0"}', sandbox)
      Components.utils.evalInSandbox("screen = {width: #{screen.width}, height: #{screen.height}}", sandbox)
      Components.utils.evalInSandbox("document.isFullscreen = #{@currentDocument().remifiFullscreen == true}", sandbox)
      Components.utils.evalInSandbox("window.browserX = #{browserX} ; window.browserY = #{browserY}", sandbox)
      
      Components.utils.evalInSandbox(zepto, sandbox)
      Components.utils.evalInSandbox('$ = Zepto', sandbox)
    
    sandbox
  
  views: (callback) =>
    views = new Remifi.Views.Base(@env)
    callback(views)
    views.html()
    
  isRunning: =>
    @server.isRunning
  
  handleRequest: (request, response) =>
    controller = new Remifi.Controller(@, request, response);
    controller.process(request, response)
  
  newVersionAvailable: (version, tracking) =>
    @xpiPath = "#{@filePath}/#{version}.xpi?#{tracking}"
    @updateAvailable = true
  
  toggle: =>
    if @server.isRunning
      Application.prefs.setValue(@onSetting, false)
      @unload()
    else
      Application.prefs.setValue(@onSetting, true)
      @load()
      @view.openSplashPage()
  
  refresh: =>
    @view.toggle(@isRunning())
  
  load: =>
    @server.start()
    @websocket.start() if @websocket
    @view.toggle(true)
  
  unload: =>
    @server.stop()
    @websocket.stop() if @websocket
    @view.toggle(false)
  