if (MobileRemote.Pages == null) MobileRemote.Pages = {}

MobileRemote.Pages.Windows = function(remote) {
  
  this.getBody = function(request, response) {
    if (request.path == '/windows/index.html' || request.path == '/windows/') {
      return this.index(request, response);
      
    } else if (request.path == '/windows/open.html') {
      return this.open(request, response);
      
    } else if (request.path == '/windows/add.html') {
      return this.add(request, response);
      
    } else if (request.path == '/windows/close.html') {
      return this.close(request, response);
      
    }
  }
  
  this.open = function(request, response) {
    var index = parseInt(request.params["index"]);
    if (!isNaN(index)) {
      var wm = Components.classes["@mozilla.org/appshell/window-mediator;1"].getService(Components.interfaces.nsIWindowMediator);
      var wenum = wm.getEnumerator(null);
      var count = 0;
      while (wenum.hasMoreElements()) {
        var win = wenum.getNext();
        if (index == count) {
          win.focus();
        }
        count++
      }
    }
    return this.index(request, response);
  }
  
  this.add = function(request, response) {
    // window.open("chrome://to/your/window.xul", windowName, "features");
    window.open();
    return this.index(request, response);
  }
  
  this.close = function(request, response) {
    var index = parseInt(request.params["index"]);
    if (!isNaN(index)) {
      var wenum = Components.classes["@mozilla.org/embedcomp/window-watcher;1"].getService(Components.interfaces.nsIWindowWatcher).getWindowEnumerator();
      var count = 0;
      while (wenum.hasMoreElements()) {
        var win = wenum.getNext();
        if (index == count && win.MobileRemote.isReference == true) {
          win.close();
        } 
        count++
      }
    }
    return this.index(request, response);
  }
  
  this.index = function(request, response) {
    return remote.views(function(v) {
      
      v.page('page1', function() {
        v.toolbar('Windows', {left: {title: 'back', url: '/'}});
        
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
          
          windows.push({
            title: win.name || win.document.title || "(Untitled)",
            url: '/windows/open.html?index=' + count,
            // active: (tab == gBrowser.mCurrentTab),
            actions: actions
          })
          
          count++;
        }
        
        v.list(windows);
        
        v.systemApps([
          null,
          null,
          null,
          {
            title: "add window",
            url: "/windows/add.html"
          }
        ]);
        
        
      });
      
    });
  };
  
};
