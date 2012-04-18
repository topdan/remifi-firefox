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
    
    return remote.pages.apps.render(request, response);
  }
  
  this.add = function(request, response) {
    // window.open("chrome://to/your/window.xul", windowName, "features");
    var url = null;
    if (request.params["url"])
      url = remote.pages.controls.polishURL(request.params["url"]);
    
    if (url)
      window.open(url);
    else
      window.open();
    
    return remote.pages.apps.render(request, response);
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
    return this.tabs.index(request, response);
  };
};
