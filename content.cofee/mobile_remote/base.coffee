class Base
  MobileRemote.Base = Base
  
  constructor: (@env) ->
    @view = null
    
    @pages = {}
    @pages.apps      = new MobileRemote.Pages.Apps(@)
    @pages.home      = new MobileRemote.Pages.Home(@)
    @pages.tabs      = new MobileRemote.Pages.Tabs(@)
    @pages.windows   = new MobileRemote.Pages.Windows(@)
    @pages.controls  = new MobileRemote.Pages.Controls(@)
    @pages.keyboard  = new MobileRemote.Pages.Keyboard(@)
    @pages.mouse     = new MobileRemote.Pages.Mouse(@)
    @pages.error     = new MobileRemote.Pages.Error(@)
    @pages.notFound  = new MobileRemote.Pages.NotFound(@)
    @pages.noBody    = new MobileRemote.Pages.NoBody(@)
    @pages.settings  = new MobileRemote.Pages.Settings(@)
    @pages.bookmarklets = new MobileRemote.Pages.Bookmarklets(@)
  
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
      
      zepto = @env.fileContent('/apps/lib/zepto.js')
      Components.utils.evalInSandbox('navigator = {userAgent: "Mozilla/5.0 (Macintosh Intel Mac OS X 10.5 rv:11.0) Gecko/20100101 Firefox/11.0"}', sandbox)
      Components.utils.evalInSandbox("screen = {width: #{screen.width}, height: #{screen.height}}", sandbox)
      Components.utils.evalInSandbox("document.isFullscreen = #{@currentDocument().mobileRemoteFullscreen == true}", sandbox)
      Components.utils.evalInSandbox("window.browserX = #{browserX} ; window.browserY = #{browserY}", sandbox)
      
      Components.utils.evalInSandbox(zepto, sandbox)
      Components.utils.evalInSandbox('$ = Zepto', sandbox)
    
    sandbox
  
  isRunning: =>
    @server.isRunning
  
  handleRequest: (request, response) =>
    controller = new MobileRemote.Controller(@, request, response);
    controller.process(request, response)
  
  toggle: =>
    if @server.isRunning
      @unload()
    else
      @load()
  
  refresh: =>
    @view.toggle(@isRunning())
  
  load: =>
    @server.start()
    @view.toggle(true)
  
  unload: =>
    @server.stop()
    @view.toggle(false)
  