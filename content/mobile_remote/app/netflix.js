MobileRemote.App.Netflix = function(remote) {
  
  this.name = "Netflix";
  this.domain = "www.netflix.com";
  this.domains = [this.domain];
  
  this.recognize = function(uri) {
    return null;
  }
  
}