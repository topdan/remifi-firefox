if (MobileRemote.Pages == null) MobileRemote.Pages = {}

MobileRemote.Pages.Mouse = function(remote) {
  var self = this;
  
  this.delay = 200;
  this.program = "/bin/mouse";
  
  this.x = null;
  this.y = null;
  
  this.render = function(request, response) {
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
      
    } else if (request.path == '/mouse/page-up.js') {
      return this.pageUp(request, response);
      
    } else if (request.path == '/mouse/page-down.js') {
      return this.pageDown(request, response);
      
    }
  }
  
  this.index = function(request, response) {
    return remote.views(function(v) {
      v.page('mouse-page', function() {
        v.toolbar();
        
        width = 310;
        height = 232;
        
        v.template('/views/mouse.html', {width: width, height: height});
        
        v.systemApps([
          {title: 'keyboard', url: '/keyboard/', icon: {url: '/static/images/keyboard.png'}},
          null,
          {title: 'page up', url: '/mouse/page-up.js', icon: {url: '/static/images/pageup.png'}},
          {title: 'page down', url: '/mouse/page-down.js', icon: {url: '/static/images/pagedown.png'}},
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
      actualMouseAction('over', null, this.x, this.y);
    }
  }
  
  this.up = function(request, response) {
    if (this.x && this.y) {
      this.y -= 5;
      actualMouseAction('over', null, this.x, this.y);
    }
  }
  
  this.down = function(request, response) {
    if (this.x && this.y) {
      this.y += 5;
      actualMouseAction('over', null, this.x, this.y);
    }
  }
  
  this.left = function(request, response) {
    if (this.x && this.y) {
      this.x -= 5;
      actualMouseAction('over', null, this.x, this.y);
    }
  }
  
  this.right = function(request, response) {
    if (this.x && this.y) {
      this.x += 5;
      actualMouseAction('over', null, this.x, this.y);
    }
  }
  
  this.click = function(request, response) {
    if (this.x && this.y) {
      actualMouseAction('click', null, this.x, this.y);
    }
  }
  
  this.pageUp = function(request, response) {
    var s = Components.utils.Sandbox(content);
    s.window = remote.currentBrowser().contentWindow;
    s.document = remote.currentBrowser().contentDocument;
    
    Components.utils.evalInSandbox("window.scrollTo(0, Math.max(0, window.scrollY - window.innerHeight/2));", s);
  }
  
  this.pageDown = function(request, response) {
    var s = Components.utils.Sandbox(content);
    s.window = remote.currentBrowser().contentWindow;
    s.document = remote.currentBrowser().contentDocument;
    
    Components.utils.evalInSandbox("window.scrollTo(0, window.scrollY + window.innerHeight/2);", s);
  }
  
  this.action = function(type, delay, x, y, x2, y2, up) {
    actualMouseAction(type, delay, x, y, x2, y2, up);
  }
  
  var actualMouseAction = function(type, delay, x, y, x2, y2, up) {
    var args = null;
    
    if (x >= screen.width)
      x = screen.width - 1;
    else if (x < 0)
      x = 0;
    
    if (y >= screen.height)
      y = screen.height - 1;
    else if (y < 0)
      y = 0;
    
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
    
    if (type == 'click' && delay && delay != 0) {
      actualMouseAction('over', null, x, y);
      setTimeout(function() { remote.env.exec(self.program, args) }, delay);
      
    } else if (args) {
      remote.env.exec(self.program, args)
    }
  }
  
};
