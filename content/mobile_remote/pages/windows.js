(function() {
  var Windows,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  Windows = (function() {

    Windows.name = 'Windows';

    MobileRemote.Pages.Windows = Windows;

    function Windows(remote) {
      this.remote = remote;
      this.close = __bind(this.close, this);

      this.add = __bind(this.add, this);

      this.open = __bind(this.open, this);

      this.index = __bind(this.index, this);

      this.render = __bind(this.render, this);

    }

    Windows.prototype.render = function(request, response) {
      if (request.path === '/windows/index.html' || request.path === '/windows/') {
        return this.index(request, response);
      } else if (request.path === '/windows/open.html') {
        return this.open(request, response);
      } else if (request.path === '/windows/add.html') {
        return this.add(request, response);
      } else if (request.path === '/windows/close.html') {
        return this.close(request, response);
      }
    };

    Windows.prototype.index = function(request, response) {
      return this.remote.pages.tabs.index(request, response);
    };

    Windows.prototype.open = function(request, response) {
      var count, index, wenum, win, wm;
      index = parseInt(request.params["index"]);
      if (!isNaN(index)) {
        wm = Components.classes["@mozilla.org/appshell/window-mediator;1"].getService(Components.interfaces.nsIWindowMediator);
        wenum = wm.getEnumerator(null);
        count = 0;
        while (true) {
          if (!wenum.hasMoreElements()) {
            break;
          }
          win = wenum.getNext();
          if (index === count) {
            win.focus();
          }
          count++;
        }
      }
      return this.remote.pages.apps.render(request, response);
    };

    Windows.prototype.add = function(request, response) {
      var url;
      url = null;
      if (request.params["url"]) {
        url = this.remote.pages.controls.polishURL(request.params["url"]);
      }
      if (url) {
        window.open(url);
      } else {
        window.open();
      }
      return this.remote.pages.apps.render(request, response);
    };

    Windows.prototype.close = function(request, response) {
      var count, index, wenum, win;
      index = parseInt(request.params["index"]);
      if (!isNaN(index)) {
        wenum = Components.classes["@mozilla.org/embedcomp/window-watcher;1"].getService(Components.interfaces.nsIWindowWatcher).getWindowEnumerator();
        count = 0;
        while (true) {
          if (!wenum.hasMoreElements()) {
            break;
          }
          win = wenum.getNext();
          if (index === count && win.MobileRemote.isReference === true) {
            win.close();
          }
          count++;
        }
      }
      return this.index(request, response);
    };

    return Windows;

  })();

}).call(this);
