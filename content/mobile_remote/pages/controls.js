(function() {
  var Controls,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  Controls = (function() {

    Controls.name = 'Controls';

    MobileRemote.Pages.Controls = Controls;

    function Controls(remote) {
      this.remote = remote;
      this.waitJS = __bind(this.waitJS, this);

      this.polishURL = __bind(this.polishURL, this);

      this.wait = __bind(this.wait, this);

      this.search = __bind(this.search, this);

      this.visit = __bind(this.visit, this);

      this.forward = __bind(this.forward, this);

      this.back = __bind(this.back, this);

      this.refresh = __bind(this.refresh, this);

      this.stop = __bind(this.stop, this);

      this.home = __bind(this.home, this);

      this.render = __bind(this.render, this);

    }

    Controls.prototype.render = function(request, response) {
      if (request.path === '/controls/home.html') {
        return this.home(request, response);
      } else if (request.path === '/controls/stop.html') {
        return this.stop(request, response);
      } else if (request.path === '/controls/refresh.html') {
        return this.refresh(request, response);
      } else if (request.path === '/controls/back.html') {
        return this.back(request, response);
      } else if (request.path === '/controls/forward.html') {
        return this.forward(request, response);
      } else if (request.path === '/controls/visit.html') {
        return this.visit(request, response);
      } else if (request.path === '/controls/search.html') {
        return this.search(request, response);
      } else if (request.path === '/controls/wait.html') {
        return this.wait(request, response);
      } else if (request.path === '/controls/wait.js') {
        return this.waitJS(request, response);
      }
    };

    Controls.prototype.home = function(request, response) {
      this.remote.currentBrowser().goHome();
      return this.wait(request.params['url'], request, response);
    };

    Controls.prototype.stop = function(request, response) {
      this.remote.currentBrowser().stop();
      return this.remote.pages.apps.render(request, response);
    };

    Controls.prototype.refresh = function(request, response) {
      var doc;
      doc = this.remote.currentBrowser().contentDocument;
      doc.location.href = doc.location.href;
      return this.wait(request.params['url'], request, response);
    };

    Controls.prototype.back = function(request, response) {
      this.remote.currentBrowser().goBack();
      return this.wait(request.params['url'], request, response);
    };

    Controls.prototype.forward = function(request, response) {
      this.remote.currentBrowser().goForward();
      return this.wait(request.params['url'], request, response);
    };

    Controls.prototype.visit = function(request, response) {
      var url;
      url = this.polishURL(request.params["url"]);
      if (url) {
        this.remote.currentBrowser().contentDocument.location.href = url;
      }
      return this.wait('/', request, response);
    };

    Controls.prototype.search = function(request, response) {
      var search;
      search = request.params["q"] || "";
      request.params.url = 'http://www.google.com/search?q=' + encodeURIComponent(search) + '&ie=utf-8&oe=utf-8&aq=t&rls=org.mozilla:en-US:official&client=firefox-a';
      return this.visit(request, response);
    };

    Controls.prototype.wait = function(url, request, response) {
      return this.remote.views(function(v) {
        return v.page('controls', function() {
          v.toolbar({
            stop: true
          });
          v.template('/views/loading.html');
          return v.out.push('<script type="text/javascript">$(function() { mobileRemote.wait("' + url + '"); })</script>');
        });
      });
    };

    Controls.prototype.polishURL = function(url) {
      if (url === null || url === "") {
        return url;
      } else if (!MobileRemote.startsWith(url, 'http://') && !MobileRemote.startsWith(url, 'https://')) {
        return "http://" + url;
      } else {
        return url;
      }
    };

    Controls.prototype.waitJS = function(request, response) {
      var url;
      url = request.params["url"];
      if (this.remote.currentBrowser().webProgress.isLoadingDocument) {
        return 'setTimeout(function() { mobileRemote.waitUnlessStopped("' + url + '")}, 250);';
      } else {
        return 'mobileRemote.show("' + url + '")';
      }
    };

    return Controls;

  })();

}).call(this);
