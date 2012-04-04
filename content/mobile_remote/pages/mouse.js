if (MobileRemote.Pages == null) MobileRemote.Pages = {}

MobileRemote.Pages.Mouse = function(remote) {
  var self = this;
  
  this.delay = 200;
  this.program = "/bin/mouse";
  
  this.x = null;
  this.y = null;
  
  this.getBody = function(request, response) {
    if (request.path == '/mouse/index.html' || request.path == '/mouse/') {
      return this.index(request, response);
      
    } else if (request.path == '/mouse/over.js') {
      return this.over(request, response);
      
    } else if (request.path == '/mouse/up.js') {
      return this.up(request, response);
      
    } else if (request.path == '/mouse/down.js') {
      return this.down(request, response);
      
    } else if (request.path == '/mouse/left.js') {
      return this.left(request, response);
      
    } else if (request.path == '/mouse/right.js') {
      return this.right(request, response);
      
    } else if (request.path == '/mouse/click.js') {
      return this.click(request, response);
      
    }
  }
  
  this.index = function(request, response) {
    return remote.views(function(v) {
      v.page('mouse-page', function() {
        v.toolbar('Mouse', {right: {title: 'home', url: '/'}});
        
        v.template('/views/mouse.html', {});
        
        v.systemApps([
          {title: 'left', url: '/mouse/left.js'},
          {title: 'up', url: '/mouse/up.js'},
          {title: 'down', url: '/mouse/down.js'},
          {title: 'right', url: '/mouse/right.js'}
        ]);
        
      });
    });
  };
  
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
  
  this.up = function(request, response) {
    if (this.x && this.y) {
      this.y -= 5;
      actualMouseAction('over', this.x, this.y);
    }
  }
  
  this.down = function(request, response) {
    if (this.x && this.y) {
      this.y += 5;
      actualMouseAction('over', this.x, this.y);
    }
  }
  
  this.left = function(request, response) {
    if (this.x && this.y) {
      this.x -= 5;
      actualMouseAction('over', this.x, this.y);
    }
  }
  
  this.right = function(request, response) {
    if (this.x && this.y) {
      this.x += 5;
      actualMouseAction('over', this.x, this.y);
    }
  }
  
  this.click = function(request, response) {
    if (this.x && this.y) {
      actualMouseAction('click', this.x, this.y);
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
