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
  this.pages.mouse     = new MobileRemote.Pages.Mouse(this);
  this.pages.error     = new MobileRemote.Pages.Error(this);
  this.pages.notFound  = new MobileRemote.Pages.NotFound(this);
  this.pages.noBody    = new MobileRemote.Pages.NoBody(this);
  
  this.currentWindow = function() {
    var wm = Components.classes["@mozilla.org/appshell/window-mediator;1"].getService(Components.interfaces.nsIWindowMediator);
    return wm.getMostRecentWindow("navigator:browser");
  }
  
  this.currentBrowser = function() {
    return this.currentWindow().getBrowser();
  }
  
  // this.currentDocument = function() {
  //   return this.currentBrowser().contentDocument;
  // }
  // 
  // // TODO insecure
  // this.$ = function(selector) {
  //   return jQuery(this.currentDocument()).find(selector);
  // }
  
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