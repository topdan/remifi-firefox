MobileRemote = {}

MobileRemote.Base = function(env) {
  var self = this;
  
  this.env = env;
  this.view = null;
  
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