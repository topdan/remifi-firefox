MobileRemote.Response = function() {
  var self = this;
  
  this.code = 200;
  this.message = "OK";
  this.headers = {};
  
  this.headersString = function() {
    var webpage = "HTTP/1.1 " + this.code + " " + this.message + "\r\n";
    for (var key in this.headers) {
      webpage += key + ": " + this.headers[key] + "\r\n";
    }
    webpage += "\r\n";
    return webpage;
  }
  
}