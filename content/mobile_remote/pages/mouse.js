(function() {
  var Mouse,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  Mouse = (function() {

    Mouse.name = 'Mouse';

    MobileRemote.Pages.Mouse = Mouse;

    function Mouse(remote) {
      this.remote = remote;
      this.actualMouseAction = __bind(this.actualMouseAction, this);

      this.action = __bind(this.action, this);

      this.pageDown = __bind(this.pageDown, this);

      this.pageUp = __bind(this.pageUp, this);

      this.click = __bind(this.click, this);

      this.right = __bind(this.right, this);

      this.left = __bind(this.left, this);

      this.down = __bind(this.down, this);

      this.up = __bind(this.up, this);

      this.over = __bind(this.over, this);

      this.index = __bind(this.index, this);

      this.render = __bind(this.render, this);

      this.delay = 200;
      this.program = "/bin/mouse";
      this.x = null;
      this.y = null;
    }

    Mouse.prototype.render = function(request, response) {
      if (request.path === '/mouse/index.html' || request.path === '/mouse/') {
        return this.index(request, response);
      } else if (request.path === '/mouse/over.js') {
        return this.over(request, response);
      } else if (request.path === '/mouse/up.js') {
        return this.up(request, response);
      } else if (request.path === '/mouse/down.js') {
        return this.down(request, response);
      } else if (request.path === '/mouse/left.js') {
        return this.left(request, response);
      } else if (request.path === '/mouse/right.js') {
        return this.right(request, response);
      } else if (request.path === '/mouse/click.js') {
        return this.click(request, response);
      } else if (request.path === '/mouse/page-up.js') {
        return this.pageUp(request, response);
      } else if (request.path === '/mouse/page-down.js') {
        return this.pageDown(request, response);
      }
    };

    Mouse.prototype.index = function(request, response) {
      return this.remote.views(function(v) {
        return v.page('mouse-page', function() {
          var height, width;
          v.toolbar();
          width = 310;
          height = 232;
          v.template('/views/mouse.html', {
            width: width,
            height: height
          });
          return v.systemApps([
            {
              title: 'keyboard',
              url: '/keyboard/',
              icon: {
                url: '/static/images/keyboard.png'
              }
            }, null, {
              title: 'page up',
              url: '/mouse/page-up.js',
              icon: {
                url: '/static/images/pageup.png'
              }
            }, {
              title: 'page down',
              url: '/mouse/page-down.js',
              icon: {
                url: '/static/images/pagedown.png'
              }
            }
          ]);
        });
      });
    };

    Mouse.prototype.over = function(request, response) {
      var sx, sy, x, y;
      x = parseFloat(request.params["x"]);
      y = parseFloat(request.params["y"]);
      if (!(isNaN(x) || isNaN(y))) {
        sx = screen.width;
        sy = screen.height;
        this.x = Math.floor(sx * x);
        this.y = Math.floor(sy * y);
        return this.actualMouseAction('over', null, this.x, this.y);
      }
    };

    Mouse.prototype.up = function(request, response) {
      if (this.x && this.y) {
        this.y -= 5;
        return this.actualMouseAction('over', null, this.x, this.y);
      }
    };

    Mouse.prototype.down = function(request, response) {
      if (this.x && this.y) {
        this.y += 5;
        return this.actualMouseAction('over', null, x, y);
      }
    };

    Mouse.prototype.left = function(request, response) {
      if (this.x && this.y) {
        this.x -= 5;
        return this.actualMouseAction('over', null, this.x, this.y);
      }
    };

    Mouse.prototype.right = function(request, response) {
      if (this.x && this.y) {
        this.x += 5;
        return this.actualMouseAction('over', null, this.x, this.y);
      }
    };

    Mouse.prototype.click = function(request, response) {
      if (this.x && this.y) {
        return this.actualMouseAction('click', null, this.x, this.y);
      }
    };

    Mouse.prototype.pageUp = function(request, response) {
      var s;
      s = Components.utils.Sandbox(content);
      s.window = this.remote.currentBrowser().contentWindow;
      s.document = this.remote.currentBrowser().contentDocument;
      return Components.utils.evalInSandbox("window.scrollTo(0, Math.max(0, window.scrollY - window.innerHeight/2));", s);
    };

    Mouse.prototype.pageDown = function(request, response) {
      var s;
      s = Components.utils.Sandbox(content);
      s.window = this.remote.currentBrowser().contentWindow;
      s.document = this.remote.currentBrowser().contentDocument;
      return Components.utils.evalInSandbox("window.scrollTo(0, window.scrollY + window.innerHeight/2);", s);
    };

    Mouse.prototype.action = function(type, delay, x, y, x2, y2, up) {
      return this.actualMouseAction(type, delay, x, y, x2, y2, up);
    };

    Mouse.prototype.actualMouseAction = function(type, delay, x, y, x2, y2, up) {
      var args, callback;
      args = null;
      if (x >= screen.width) {
        x = screen.width - 1;
      } else if (x < 0) {
        x = 0;
      }
      if (y >= screen.height) {
        y = screen.height - 1;
      } else if (y < 0) {
        y = 0;
      }
      switch (type) {
        case 'click':
          args = ["-a", 1, "-x", x, "-y", y];
          break;
        case 'drag':
          args = ["-a", 5, "-x1", x, "-y1", y, "-x2", x2, "-y2", y2, "-up", up];
          break;
        case 'over':
          args = ["-a", 2, "-x", x, "-y", y];
      }
      if (type === 'click' && delay && delay !== 0) {
        this.actualMouseAction('over', null, x, y);
        callback = function() {
          return this.remote.env.exec(this.program, args);
        };
        setTimeout(callback, delay);
      } else if (args) {
        this.remote.env.exec(this.program, args);
      }
      return null;
    };

    return Mouse;

  })();

}).call(this);
