MobileRemote = {}

MobileRemote.Base = function(env) {
  var self = this;
  
  this.env = env;
  
  this.load = function() {
    this.server.start();
  }
  
  this.unload = function() {
    this.server.stop();
  }
  
}