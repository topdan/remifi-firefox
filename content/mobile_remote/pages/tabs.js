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
    if (index) gBrowser.selectTabAtIndex(index)
    return this.index(request, response);
  }
  
  this.add = function(request, response) {
    gBrowser.addTab("")
    return this.index(request, response);
  }
  
  this.close = function(request, response) {
    var index = request.params['index'];
    if (index) {
      var tab = gBrowser.mTabs[index];
      if (tab) gBrowser.removeTab(tab);
    }
    return this.index(request, response);
  }
  
  this.index = function(request, response) {
    return remote.views(function(v) {
      
      v.page('page1', function() {
        v.toolbar('Tabs', {left: {title: 'back', url: '/'}});
        
        var tabs = [];
        for (var i=0 ; i < gBrowser.mTabs.length ; i++) {
          var tab = gBrowser.mTabs[i];
          var browser = gBrowser.getBrowserForTab(tab);
          
          tabs.push({
            title: browser.contentDocument.title || "(Untitled)",
            url: '/tabs/open.html?index=' + i,
            active: (tab == gBrowser.mCurrentTab),
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
