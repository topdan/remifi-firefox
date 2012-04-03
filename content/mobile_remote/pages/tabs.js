if (MobileRemote.Pages == null) MobileRemote.Pages = {}

MobileRemote.Pages.Tabs = function(remote) {
  // TODO extract firefox specific stuff
  
  this.getBody = function(request, response) {
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
    return this.index(request, response);
  }
  
  this.add = function(request, response) {
    remote.currentBrowser().addTab("")
    return this.index(request, response);
  }
  
  this.close = function(request, response) {
    var index = request.params['index'];
    if (index) {
      var tab = remote.currentBrowser().mTabs[index];
      if (tab) remote.currentBrowser().removeTab(tab);
    }
    return this.index(request, response);
  }
  
  this.index = function(request, response) {
    return remote.views(function(v) {
      
      var currentBrowser = remote.currentBrowser();
      
      v.page('page1', function() {
        v.toolbar('Tabs', {left: {title: 'back', url: '/'}});
        
        var tabs = [];
        for (var i=0 ; i < currentBrowser.mTabs.length ; i++) {
          var tab = currentBrowser.mTabs[i];
          var browser = currentBrowser.getBrowserForTab(tab);
          
          tabs.push({
            title: browser.contentDocument.title || "(Untitled)",
            url: '/tabs/open.html?index=' + i,
            active: (tab == currentBrowser.mCurrentTab),
            actions: [
              {
                title: 'close',
                url: '/tabs/close.html?index=' + i
              }
            ]
          })
        }
        
        v.list(tabs);
        
        v.systemApps([
          null,
          null,
          null,
          {
            title: "add tab",
            url: "/tabs/add.html"
          }
        ]);
        
        
      });
      
    });
  };
  
};
