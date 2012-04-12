MobileRemote = {}

MobileRemote.Base = function(env) {
  var self = this;
  
  this.env = env;
  this.view = null;
  
  this.pages = {};
  this.pages.apps      = new MobileRemote.Pages.Apps(this);
  this.pages.home      = new MobileRemote.Pages.Home(this);
  this.pages.tabs      = new MobileRemote.Pages.Tabs(this);
  this.pages.windows   = new MobileRemote.Pages.Windows(this);
  this.pages.controls  = new MobileRemote.Pages.Controls(this);
  this.pages.keyboard  = new MobileRemote.Pages.Keyboard(this);
  this.pages.mouse     = new MobileRemote.Pages.Mouse(this);
  this.pages.error     = new MobileRemote.Pages.Error(this);
  this.pages.notFound  = new MobileRemote.Pages.NotFound(this);
  this.pages.noBody    = new MobileRemote.Pages.NoBody(this);
  this.pages.bookmarklets = new MobileRemote.Pages.Bookmarklets(this);
  
  this.currentURL = function() {
    return this.currentDocument().location.href;
  }
  
  this.currentWindow = function() {
    var wm = Components.classes["@mozilla.org/appshell/window-mediator;1"].getService(Components.interfaces.nsIWindowMediator);
    return wm.getMostRecentWindow("navigator:browser");
  }
  
  this.currentBrowser = function() {
    return this.currentWindow().getBrowser();
  }
  
  this.currentDocument = function() {
    return this.currentBrowser().contentDocument;
  }
  
  this.createSandbox = function(url, options) {
    if (url == null) url = this.currentURL();
    if (options == null) options = {};
    
    var sandbox = Components.utils.Sandbox(url);
    
    if (options.zepto) {
      sandbox.window = this.currentBrowser().contentWindow;
      sandbox.document = this.currentBrowser().contentDocument;
      
      var zepto = env.fileContent('/apps/lib/zepto.js');
      Components.utils.evalInSandbox('navigator = {userAgent: "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.5; rv:11.0) Gecko/20100101 Firefox/11.0"}', sandbox);
      Components.utils.evalInSandbox('screen = {width: ' + screen.width + ', height: ' + screen.height + '}', sandbox)
      Components.utils.evalInSandbox('document.isFullscreen = ' + (this.currentDocument().mobileRemoteFullscreen == true), sandbox);
      Components.utils.evalInSandbox(zepto, sandbox);
      Components.utils.evalInSandbox('$ = Zepto', sandbox);
    }
    
    return sandbox;
  }
  
  this.isRunning = function() {
    return this.server.isRunning;
  }
  
  this.handleRequest = function(request, response) {
    var controller = new MobileRemote.Controller(self, request, response);
    return controller.process(request, response);
  }
  
  this.toggle = function() {
    if (this.server.isRunning) {
      this.unload();
    } else {
      this.load();
    }
  }
  
  this.refresh = function() {
    this.view.toggle(this.isRunning());
  }
  
  this.load = function() {
    this.server.start();
    this.view.toggle(true);
  }
  
  this.unload = function() {
    this.server.stop();
    this.view.toggle(false);
  }
  
}