(function() {
  var Tabs,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  Tabs = (function() {

    Tabs.name = 'Tabs';

    MobileRemote.Pages.Tabs = Tabs;

    function Tabs(remote) {
      this.remote = remote;
      this.windowsList = __bind(this.windowsList, this);

      this.tabsList = __bind(this.tabsList, this);

      this.index = __bind(this.index, this);

      this.close = __bind(this.close, this);

      this.add = __bind(this.add, this);

      this.open = __bind(this.open, this);

      this.render = __bind(this.render, this);

    }

    Tabs.prototype.render = function(request, response) {
      if (request.path === '/tabs/index.html' || request.path === '/tabs/') {
        return this.index(request, response);
      } else if (request.path === '/tabs/open.html') {
        return this.open(request, response);
      } else if (request.path === '/tabs/add.html') {
        return this.add(request, response);
      } else if (request.path === '/tabs/close.html') {
        return this.close(request, response);
      }
    };

    Tabs.prototype.open = function(request, response) {
      var index;
      index = request.params["index"];
      if (index) {
        this.remote.currentBrowser().selectTabAtIndex(index);
      }
      return this.remote.pages.apps.render(request, response);
    };

    Tabs.prototype.add = function(request, response) {
      var url;
      url = this.remote.pages.controls.polishURL(request.params["url"]) || "";
      gBrowser.selectedTab = this.remote.currentBrowser().addTab(url);
      return this.remote.pages.apps.render(request, response);
    };

    Tabs.prototype.close = function(request, response) {
      var currentBrowser, currentWindow, index, tab;
      currentWindow = this.remote.currentWindow();
      currentBrowser = this.remote.currentBrowser();
      index = request.params['index'];
      if (index && (currentBrowser.mTabs.length > 1 || currentWindow.MobileRemote.isReference === true)) {
        tab = this.remote.currentBrowser().mTabs[index];
        if (tab) {
          this.remote.currentBrowser().removeTab(tab);
        }
      }
      return this.index(request, response);
    };

    Tabs.prototype.index = function(request, response) {
      var remote, tabsList, windowsList;
      tabsList = this.tabsList;
      windowsList = this.windowsList;
      remote = this.remote;
      return this.remote.views(function(v) {
        return v.page('tabs', function() {
          v.toolbar();
          tabsList(v);
          windowsList(v);
          v.br();
          v.button('Open on Mobile', remote.currentURL(), {
            openLocally: true
          });
          v.button('New Tab', '/tabs/add.html');
          return v.button('New Window', '/windows/add.html');
        });
      });
    };

    Tabs.prototype.tabsList = function(v) {
      var actions, browser, currentBrowser, currentTabIndex, currentWindow, i, tab, tabs, _i, _len, _ref;
      currentWindow = this.remote.currentWindow();
      currentBrowser = this.remote.currentBrowser();
      currentTabIndex = null;
      tabs = [];
      i = -1;
      _ref = currentBrowser.mTabs;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        tab = _ref[_i];
        i++;
        browser = currentBrowser.getBrowserForTab(tab);
        if (tab === currentBrowser.mCurrentTab) {
          currentTabIndex = i;
        }
        actions = null;
        if (currentBrowser.mTabs.length > 1 || currentWindow.MobileRemote.isReference === true) {
          actions = [
            {
              title: 'close',
              url: '/tabs/close.html?index=' + i
            }
          ];
        } else {
          actions = [
            {
              title: "can't close last tab",
              url: '/tabs/index.html'
            }
          ];
        }
        tabs.push({
          title: browser.contentDocument.title || "(Untitled)",
          url: '/tabs/open.html?index=' + i,
          active: tab === currentBrowser.mCurrentTab,
          actions: actions
        });
      }
      v.title("Tabs");
      return v.list(tabs);
    };

    Tabs.prototype.windowsList = function(v) {
      var actions, count, currentWindow, currentWindowIndex, orderedWindows, wenum, win, windows;
      currentWindowIndex = null;
      orderedWindows = Components.classes["@mozilla.org/appshell/window-mediator;1"].getService(Components.interfaces.nsIWindowMediator);
      currentWindow = orderedWindows.getZOrderDOMWindowEnumerator(null, true).getNext();
      windows = [];
      wenum = Components.classes["@mozilla.org/embedcomp/window-watcher;1"].getService(Components.interfaces.nsIWindowWatcher).getWindowEnumerator();
      count = 0;
      while (true) {
        if (!wenum.hasMoreElements()) {
          break;
        }
        win = wenum.getNext();
        actions = null;
        if (count === 0) {
          actions = [
            {
              title: "can't close main window",
              url: '/windows/index.html'
            }
          ];
        } else {
          actions = [
            {
              title: 'close',
              url: '/windows/close.html?index=' + count
            }
          ];
        }
        if (currentWindow === win && win.MobileRemote.isReference === true) {
          currentWindowIndex = count;
        }
        windows.push({
          title: win.name || win.document.title || "(Untitled)",
          url: '/windows/open.html?index=' + count,
          actions: actions,
          active: currentWindow === win
        });
        count++;
      }
      v.title("Windows");
      return v.list(windows);
    };

    return Tabs;

  })();

}).call(this);
