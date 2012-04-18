(function() {
  var About,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  About = (function() {

    About.name = 'About';

    MobileRemote.App.About = About;

    function About(remote) {
      this.remote = remote;
      this.sessionRestoreRestore = __bind(this.sessionRestoreRestore, this);

      this.sessionRestoreStartNewSession = __bind(this.sessionRestoreStartNewSession, this);

      this.sessionRestore = __bind(this.sessionRestore, this);

      this.render = __bind(this.render, this);

    }

    About.prototype.render = function(uri, request, response) {
      if (uri.toString() === 'about:home') {
        return this.remote.pages.home.index(request, response);
      } else if (uri.toString() === "about:sessionrestore") {
        if (request.path === "/apps/about/sessionrestore/start-new-session.html") {
          return this.sessionRestoreStartNewSession(request, response);
        } else if (request.path === "/apps/about/sessionrestore/restore.html") {
          return this.sessionRestoreRestore(request, response);
        } else {
          return this.sessionRestore(request, response);
        }
      } else if (uri.toString() === "about:blank") {
        return this.remote.pages.home.index(request, response);
      }
    };

    About.prototype.sessionRestore = function(request, response) {
      return this.remote.views(function(v) {
        return v.page('firefox-session-restore', function() {
          v.toolbar();
          v.br();
          v.br();
          v.button("Start New Session", '/apps/about/sessionrestore/start-new-session.html', {
            type: 'primary'
          });
          v.br();
          return v.button("Restore", '/apps/about/sessionrestore/restore.html');
        });
      });
    };

    About.prototype.sessionRestoreStartNewSession = function(request, response) {
      var s;
      s = Components.utils.Sandbox(content);
      s.win = content;
      Components.utils.evalInSandbox("if (win.startNewSession) win.startNewSession();", s);
      return this.remote.pages.controls.wait('/', request, response);
    };

    About.prototype.sessionRestoreRestore = function(request, response) {
      var s;
      s = Components.utils.Sandbox(content);
      s.win = content;
      Components.utils.evalInSandbox("try { win.restoreSession(); } catch(err) { }", s);
      return this.remote.pages.controls.wait('/', request, response);
    };

    return About;

  })();

}).call(this);
