if (MobileRemote.Pages == null) MobileRemote.Pages = {}

MobileRemote.Pages.Mouse = function(remote) {
  var self = this;
  
  this.getBody = function(request, response) {
    if (request.path == '/mouse/move.js') {
      return this.move(request, response);
      
    }
  }
  
  this.move = function(request, response) {
    var x = request.params["x"];
    var y = request.params["y"];
    
  }
  
};
