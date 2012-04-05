if (MobileRemote.Pages == null) MobileRemote.Pages = {}

MobileRemote.Pages.Windows = function(remote) {
  
  this.tabs = new MobileRemote.Pages.Tabs(remote);
  
  this.render = function(request, response) {
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
    
    return this.tabs.index(request, response);
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
      
      var currentWindowIndex = null;
      var orderedWindows = Components.classes["@mozilla.org/appshell/window-mediator;1"].getService(Components.interfaces.nsIWindowMediator);
      var currentWindow = orderedWindows.getZOrderDOMWindowEnumerator(null, true).getNext();
      
      v.page('windows', function() {
        v.toolbar('Windows', {left: {title: 'tabs', url: '/tabs/index.html'}});
        
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
        
        v.list(windows);
        
        apps = [null, null]
        if (currentWindowIndex != null)
          apps.push({title: 'close', url: "/windows/close.html?index=" + currentWindowIndex})
        else
          apps.push(null);
        
        apps.push({title: 'add window', url: '/windows/add.html'});
        v.systemApps(apps);
      });
      
    });
  };
  
};
