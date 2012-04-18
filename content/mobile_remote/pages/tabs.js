if (MobileRemote.Pages == null) MobileRemote.Pages = {}

MobileRemote.Pages.Tabs = function(remote) {
  // TODO extract firefox specific stuff
  
  this.render = function(request, response) {
    if (request.path == '/tabs/index.html' || request.path == '/tabs/') {
      return this.index(request, response);
      
    } else if (request.path == '/tabs/open.html') {
      return this.open(request, response);
      
    } else if (request.path == '/tabs/add.html') {
      return this.add(request, response);
      
    } else if (request.path == '/tabs/close.html') {
      return this.close(request, response);
      
    }
  }
  
  this.open = function(request, response) {
    var index = request.params["index"];
    if (index) remote.currentBrowser().selectTabAtIndex(index)
    return remote.pages.apps.render(request, response);
  }
  
  this.add = function(request, response) {
    var url = remote.pages.controls.polishURL(request.params["url"]) || "";
    gBrowser.selectedTab = remote.currentBrowser().addTab(url);
    return remote.pages.apps.render(request, response);
  }
  
  this.close = function(request, response) {
    var currentWindow = remote.currentWindow();
    var currentBrowser = remote.currentBrowser();
    var index = request.params['index'];
    if (index && (currentBrowser.mTabs.length > 1 || currentWindow.MobileRemote.isReference == true)) {
      var tab = remote.currentBrowser().mTabs[index];
      if (tab) remote.currentBrowser().removeTab(tab);
    }
    
    return this.index(request, response);
  }
  
  this.index = function(request, response) {
    return remote.views(function(v) {
      
      v.page('tabs', function() {
        v.toolbar();
        tabsList(v);
        windowsList(v);
        
        v.br();
        v.button('Open on Mobile', remote.currentURL(), {openLocally: true});
        v.button('New Tab', '/tabs/add.html');
        v.button('New Window', '/windows/add.html');
      });
      
    });
    
  };
  
  
  var tabsList = function(v) {
    var currentWindow = remote.currentWindow();
    var currentBrowser = remote.currentBrowser();
    var currentTabIndex = null;
    
    var tabs = [];
    for (var i=0 ; i < currentBrowser.mTabs.length ; i++) {
      var tab = currentBrowser.mTabs[i];
      var browser = currentBrowser.getBrowserForTab(tab);
      
      if (tab == currentBrowser.mCurrentTab)
        currentTabIndex = i;
      
      var actions = null;
      if (currentBrowser.mTabs.length > 1 || currentWindow.MobileRemote.isReference == true)
        actions = [{title: 'close', url: '/tabs/close.html?index=' + i}]
      else
        actions = [{title: "can't close last tab", url: '/tabs/index.html'}]
      
      tabs.push({
        title: browser.contentDocument.title || "(Untitled)",
        url: '/tabs/open.html?index=' + i,
        active: (tab == currentBrowser.mCurrentTab),
        actions: actions
      })
    }
    
    v.title("Tabs");
    v.list(tabs);
  }
  
  var windowsList = function(v) {
    var currentWindowIndex = null;
    var orderedWindows = Components.classes["@mozilla.org/appshell/window-mediator;1"].getService(Components.interfaces.nsIWindowMediator);
    var currentWindow = orderedWindows.getZOrderDOMWindowEnumerator(null, true).getNext();
    
    var windows = [];
    var wenum = Components.classes["@mozilla.org/embedcomp/window-watcher;1"].getService(Components.interfaces.nsIWindowWatcher).getWindowEnumerator();
    var count = 0;
    while (wenum.hasMoreElements()) {
      var win = wenum.getNext();
      
      var actions = null;
      if (count == 0) {
        actions = [{
          title: "can't close main window",
          url: '/windows/index.html'
        }]
      } else {
        actions = [{
          title: 'close',
          url: '/windows/close.html?index=' + count
        }]
      }
      
      if (currentWindow == win && win.MobileRemote.isReference == true)
        currentWindowIndex = count
      
      windows.push({
        title: win.name || win.document.title || "(Untitled)",
        url: '/windows/open.html?index=' + count,
        actions: actions,
        active: (currentWindow == win)
      })
      
      count++;
    }
    
    v.title("Windows");
    v.list(windows);
  }
  
};
