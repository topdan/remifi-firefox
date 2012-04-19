(function() {
  var Keyboard,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  Keyboard = (function() {

    Keyboard.name = 'Keyboard';

    MobileRemote.Pages.Keyboard = Keyboard;

    function Keyboard(remote) {
      this.remote = remote;
      this.currentText = __bind(this.currentText, this);

      this.press = __bind(this.press, this);

      this.pressReturn = __bind(this.pressReturn, this);

      this.pressEscape = __bind(this.pressEscape, this);

      this.typeText = __bind(this.typeText, this);

      this.index = __bind(this.index, this);

      this.render = __bind(this.render, this);

      this.delay = 200;
      this.program = "/bin/keyboard";
      this.x = null;
      this.y = null;
    }

    Keyboard.prototype.render = function(request, response) {
      if (request.path === '/keyboard/index.html' || request.path === '/keyboard/') {
        return this.index(request, response);
      } else if (request.path === '/keyboard/type.html') {
        return this.typeText(request, response);
      } else if (request.path === '/keyboard/escape.js') {
        return this.pressEscape(request, response);
      } else if (request.path === '/keyboard/return.js') {
        return this.pressReturn(request, response);
      }
    };

    Keyboard.prototype.index = function(request, response) {
      var currentText;
      currentText = this.currentText;
      return this.remote.views(function(v) {
        return v.page('keyboard-page', function() {
          v.toolbar();
          v.template('/views/keyboard.html', {
            current: currentText()
          });
          return v.systemApps([
            {
              title: 'mouse',
              url: '/mouse/',
              icon: {
                url: '/static/images/mouse.png'
              }
            }, null, null, null
          ]);
        });
      });
    };

    Keyboard.prototype.typeText = function(request, response) {
      var code, sandbox, text, view;
      sandbox = this.remote.createSandbox(null, {
        zepto: true
      });
      text = request.params["text"] || "";
      view = new MobileRemote.Views.Base(this.remote.env);
      code = 'Zepto(":focus").val("' + view.escape(text) + '")';
      try {
        Components.utils.evalInSandbox(code, sandbox);
      } catch (err) {

      }
      return this.index(request, response);
    };

    Keyboard.prototype.pressEscape = function(request, response) {
      return this.press('escape');
    };

    Keyboard.prototype.pressReturn = function(request, response) {
      return this.press('return');
    };

    Keyboard.prototype.press = function(key) {
      if (key === 'escape' || key === 'return') {
        return this.remote.env.exec("/bin/keyboard", ['-key', key]);
      }
    };

    Keyboard.prototype.currentText = function() {
      var code, current, sandbox;
      try {
        sandbox = this.remote.createSandbox(null, {
          zepto: true
        });
        code = 'Zepto(":focus").val()';
        current = Components.utils.evalInSandbox(code, sandbox);
        if (typeof current === "string") {
          return current;
        }
      } catch (err) {
        return null;
      }
    };

    return Keyboard;

  })();

}).call(this);
