(function() {
  var Bookmarklets,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  Bookmarklets = (function() {

    Bookmarklets.name = 'Bookmarklets';

    MobileRemote.Pages.Bookmarklets = Bookmarklets;

    function Bookmarklets(remote) {
      this.remote = remote;
      this.newWindow = __bind(this.newWindow, this);

      this.newTab = __bind(this.newTab, this);

      this.visit = __bind(this.visit, this);

      this.index = __bind(this.index, this);

      this.render = __bind(this.render, this);

    }

    Bookmarklets.prototype.render = function(request, response) {
      if (request.path === '/bookmarklets/index.html' || request.path === '/bookmarklets/') {
        return this.index(request, response);
      } else if (request.path === '/bookmarklets/new-tab.html') {
        return this.newTab(request, response);
      } else if (request.path === '/bookmarklets/new-window.html') {
        return this.newWindow(request, response);
      } else if (request.path === '/bookmarklets/visit.html') {
        return this.visit(request, response);
      }
    };

    Bookmarklets.prototype.index = function(request, response) {
      return this.remote.views(function(v) {
        return v.page('bookmarklets-page', function() {
          var newTab, newWindow, referer, viewJS;
          v.toolbar();
          v.title("Bookmarklets");
          referer = request.headers["Referer"];
          referer = referer.match('(http://[^\/]+)')[0];
          viewJS = "javascript:document.location = '" + referer + "/bookmarklets/visit.html?url=' + encodeURIComponent(document.location.href);";
          newTab = "javascript:document.location = '" + referer + "/bookmarklets/new-tab.html?url=' + encodeURIComponent(document.location.href);";
          newWindow = "javascript:document.location = '" + referer + "/bookmarklets/new-window.html?url=' + encodeURIComponent(document.location.href);";
          return v.template('/views/bookmarklets.html', {
            viewJS: viewJS,
            newTab: newTab,
            newWindow: newWindow
          });
        });
      });
    };

    Bookmarklets.prototype.visit = function(request, response) {
      this.remote.pages.controls.visit(request, response);
      return this.remote.pages.controls.wait('/', request, response);
    };

    Bookmarklets.prototype.newTab = function(request, response) {
      this.remote.pages.tabs.add(request, response);
      return this.remote.pages.controls.wait('/', request, response);
    };

    Bookmarklets.prototype.newWindow = function(request, response) {
      this.remote.pages.windows.add(request, response);
      return this.remote.pages.controls.wait('/', request, response);
    };

    return Bookmarklets;

  })();

}).call(this);
