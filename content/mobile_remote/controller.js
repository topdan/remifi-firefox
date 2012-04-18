(function() {
  var Controller,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  Controller = (function() {

    Controller.name = 'Controller';

    MobileRemote.Controller = Controller;

    function Controller(remote) {
      this.remote = remote;
      this.withLayout = __bind(this.withLayout, this);

      this.findPage = __bind(this.findPage, this);

      this.process = __bind(this.process, this);

      this.layout = null;
    }

    Controller.prototype.process = function(request, response) {
      var body, doc, page, uri;
      doc = this.remote.currentBrowser().contentDocument;
      uri = new MobileRemote.URI(doc.location.href);
      page = this.findPage(request);
      body = null;
      try {
        body = page.render(request, response);
      } catch (err) {
        doc.mobileRemoteError = err;
        Components.utils.reportError(err);
        body = this.remote.pages.error.render(err, request, response);
      }
      body || (body = this.remote.pages.noBody.render(request, response));
      if (request.isXhr && request.isScript) {
        return body;
      } else if (request.isXhr) {
        response.headers["Content-Type"] = "text/html; charset=ISO-8859-1";
        return body + '<script type="text/javascript" charset="utf-8">\nsetupPages()\n</script>';
      } else {
        return this.withLayout(body);
      }
    };

    Controller.prototype.findPage = function(request) {
      if (request.path === "/home.html") {
        return this.remote.pages.home;
      } else if (request.path === "/" || MobileRemote.startsWith(request.path, '/apps/')) {
        return this.remote.pages.apps;
      } else if (MobileRemote.startsWith(request.path, '/tabs/')) {
        return this.remote.pages.tabs;
      } else if (MobileRemote.startsWith(request.path, '/windows/')) {
        return this.remote.pages.windows;
      } else if (MobileRemote.startsWith(request.path, '/controls/')) {
        return this.remote.pages.controls;
      } else if (MobileRemote.startsWith(request.path, '/mouse/')) {
        return this.remote.pages.mouse;
      } else if (MobileRemote.startsWith(request.path, '/keyboard/')) {
        return this.remote.pages.keyboard;
      } else if (MobileRemote.startsWith(request.path, '/bookmarklets/')) {
        return this.remote.pages.bookmarklets;
      } else if (MobileRemote.startsWith(request.path, '/settings/')) {
        return this.remote.pages.settings;
      } else {
        return this.remote.pages.notFound;
      }
    };

    Controller.prototype.withLayout = function(body) {
      var code, views;
      if (this.layout === null) {
        code = this.remote.env.fileContent('/views/layout.html');
        if (code === null) {
          throw "/views/layout.html was not found";
        }
        this.layout = MobileRemote.microtemplate(code);
      }
      views = new MobileRemote.Views.Base(this.remote.env);
      return this.layout({
        body: body,
        views: views
      });
    };

    return Controller;

  })();

}).call(this);
