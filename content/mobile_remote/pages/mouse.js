if (MobileRemote.Pages == null) MobileRemote.Pages = {}

MobileRemote.Pages.Mouse = function(remote) {
  var self = this;
  
  this.delay = 200;
  this.program = "/bin/mouse";
  
  this.x = null;
  this.y = null;
  
  this.getBody = function(request, response) {
    if (request.path == '/mouse/over.js') {
      return this.over(request, response);
      
    }
  }
  
  this.over = function(request, response) {
    var x = parseFloat(request.params["x"]);
    var y = parseFloat(request.params["y"]);
    
    if (!isNaN(x) && !isNaN(y)) {
      var sx = screen.width;
      var sy = screen.height;
      
      this.x = Math.floor(sx * x);
      this.y = Math.floor(sy * y);
      actualMouseAction('over', this.x, this.y);
    }
  }
  
  var actualMouseAction = function(type, x, y, x2, y2, up) {
    var args = null;
    
    switch(type) {
      case 'click':
        args = ["-a", 1, "-x", x, "-y", y];
        break;
        
      case 'drag':
        args = ["-a", 5, "-x1", x, "-y1", y, "-x2", x2, "-y2", y2, "-up", up];
        break;
        
      case 'over':
        args = ["-a", 2, "-x", x, "-y", y];
        break;
        
      default:
        break;
    }
    
    if (args) {
      remote.env.exec(self.program, args)
    }
  }
  
};
