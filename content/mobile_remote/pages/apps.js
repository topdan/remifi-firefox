(function() {
  var Apps,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  Apps = (function() {

    Apps.name = 'Apps';

    MobileRemote.Pages.Apps = Apps;

    function Apps(remote) {
      this.remote = remote;
      this.findApp = __bind(this.findApp, this);

      this.render = __bind(this.render, this);

      this.about = new MobileRemote.App.About(this.remote);
      this.list = [new MobileRemote.App.Sandbox(this.remote, 'com.topdan.google'), new MobileRemote.App.Sandbox(this.remote, 'com.topdan.youtube'), new MobileRemote.App.Sandbox(this.remote, 'com.topdan.netflix'), new MobileRemote.App.Sandbox(this.remote, 'com.topdan.hulu'), new MobileRemote.App.Sandbox(this.remote, 'com.topdan.hbo')];
    }

    Apps.prototype.render = function(request, response) {
      var app, body, doc, uri, url;
      doc = this.remote.currentBrowser().contentDocument;
      url = doc.location.href;
      uri = new MobileRemote.URI(url);
      app = null;
      body = null;
      if (MobileRemote.startsWith(url, 'about:')) {
        body = this.about.render(uri, request, response);
      } else {
        app = this.findApp(uri, request, response);
        if (app) {
          body = app.render(uri, request, response);
        }
      }
      return body || this.remote.pages.mouse.index(request, response);
    };

    Apps.prototype.findApp = function(uri, request, response) {
      var app, _i, _len, _ref;
      _ref = this.list;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        app = _ref[_i];
        if (app.domains && app.domains.indexOf(uri.host) !== -1) {
          return app;
        }
      }
      return null;
    };

    return Apps;

  })();

}).call(this);
