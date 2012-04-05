if (MobileRemote.Pages == null) MobileRemote.Pages = {}

MobileRemote.Pages.Apps = function(remote) {
  
  this.list = [
    new MobileRemote.App.About(remote),
    new MobileRemote.App.Google(remote),
    new MobileRemote.App.Youtube(remote),
    new MobileRemote.App.Hulu(remote),
    new MobileRemote.App.Netflix(remote),
    new MobileRemote.App.Hbo(remote),
    new MobileRemote.App.Cinemax(remote),
  ];
  
  this.render = function(request, response) {
    var doc = remote.currentBrowser().contentDocument;
    var uri = new MobileRemote.URI(doc.location.href);
    var appHandler = null;
    
    if (uri) {
      appHandler = this.recognize(uri, request, response);
    }
    
    if (appHandler) {
      return appHandler(request, response);
    } else {
      return remote.pages.mouse.index(request, response);
    }
  }
  
  this.recognize = function(uri, request, response) {
    for(var i=0 ; i < this.list.length ; i++) {
      var app = this.list[i];
      var func = app.recognize(uri, request, response)
      if (func) {
        return func;
      }
    }
    
    return null;
  }
  
}