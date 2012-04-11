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
      
      var currentWindow = remote.currentWindow();
      var currentBrowser = remote.currentBrowser();
      var currentTabIndex = null;
      
      v.page('tabs', function() {
        v.toolbar();
        v.title("Tabs");
        
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
        
        v.list(tabs);
        
        apps = [null, null]
        if (currentTabIndex != null && (currentBrowser.mTabs.length > 1 || currentWindow.MobileRemote.isReference == true))
          apps.push({title: 'close', url: "/tabs/close.html?index=" + currentTabIndex})
        else
          apps.push(null);
        
        apps.push({title: 'add tab', url: '/tabs/add.html'});
        v.systemApps(apps);
      });
      
    });
  };
  
};
