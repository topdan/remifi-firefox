MobileRemote = {}

MobileRemote.Base = function(env) {
  var self = this;
  
  this.env = env;
  this.view = null;
  
  this.currentWindow = function() {
    var wm = Components.classes["@mozilla.org/appshell/window-mediator;1"].getService(Components.interfaces.nsIWindowMediator);
    return wm.getMostRecentWindow("navigator:browser");
  }
  
  this.currentBrowser = function() {
    return this.currentWindow().getBrowser();
  }
  
  this.isRunning = function() {
    return this.server.isRunning;
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