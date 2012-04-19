class Apps
  MobileRemote.Pages.Apps = Apps
  
  constructor: (@remote) ->
    @about = new MobileRemote.App.About(@remote)
    @list = [
      new MobileRemote.App.Sandbox(@remote, 'com.topdan.google'),
      new MobileRemote.App.Sandbox(@remote, 'com.topdan.youtube'),
      new MobileRemote.App.Sandbox(@remote, 'com.topdan.netflix'),
      new MobileRemote.App.Sandbox(@remote, 'com.topdan.hulu'),
      new MobileRemote.App.Sandbox(@remote, 'com.topdan.hbo')
    ];
  
  render: (request, response) =>
    doc = @remote.currentBrowser().contentDocument;
    url = doc.location.href
    uri = new MobileRemote.URI(url);
    app = null;
    body = null;
    
    if MobileRemote.startsWith(url, 'about:')
      body = this.about.render(uri, request, response);
    else
      app = @findApp(uri, request, response);
      body = app.render(uri, request, response) if app
    
    body || @remote.pages.mouse.index(request, response)
  
  findApp: (uri, request, response) =>
    for app in @list
      return app if app.domains && app.domains.indexOf(uri.host) != -1
    null