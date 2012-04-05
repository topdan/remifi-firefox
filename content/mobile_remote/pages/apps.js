if (MobileRemote.Pages == null) MobileRemote.Pages = {}

MobileRemote.Pages.Apps = function(remote) {
  var self = this;
  
  this.about = new MobileRemote.App.About(remote)
  this.list = [
    new MobileRemote.App.Sandbox(remote, 'com.topdan.google'),
    new MobileRemote.App.Sandbox(remote, 'com.topdan.youtube'),
    new MobileRemote.App.Sandbox(remote, 'com.topdan.nextflix')
  ];
  
  // throw this.list[0].domain;
  
  this.render = function(request, response) {
    var doc = remote.currentBrowser().contentDocument;
    var url = doc.location.href
    var uri = new MobileRemote.URI(url);
    var app = null;
    var body = null;
    
    if (MobileRemote.startsWith(url, 'about:')) {
      body = this.about.render(uri, request, response);
    } else {
      app = findApp(uri, request, response);
      
      if (app)
        body = app.render(uri, request, response);
    }
    
    if (body == null)
      return remote.pages.mouse.index(request, response);
    else
      return body;
  }
  
  var findApp = function(uri, request, response) {
    for(var i=0 ; i < self.list.length ; i++) {
      var app = self.list[i];
      
      if (app.domains && app.domains.indexOf(uri.host) != -1) {
        return app;
      }
    }
    
    return null;
  }
  
}