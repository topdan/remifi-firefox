class Apps
  MobileRemote.Pages.Apps = Apps
  
  constructor: (@remote) ->
    @about = new MobileRemote.App.About(@remote)
    @list = [
      new MobileRemote.App.Sandbox(@remote, 'com.topdan.google'),
      new MobileRemote.App.Sandbox(@remote, 'com.topdan.youtube'),
      new MobileRemote.App.Sandbox(@remote, 'com.topdan.netflix'),
      new MobileRemote.App.Sandbox(@remote, 'com.topdan.hulu'),
      new MobileRemote.App.Sandbox(@remote, 'com.topdan.hbo'),
      new MobileRemote.App.Sandbox(@remote, 'com.topdan.cinemax'),
      new MobileRemote.App.Sandbox(@remote, 'com.topdan.reddit'),
      new MobileRemote.App.Sandbox(@remote, 'com.topdan.southparkstudios'),
      new MobileRemote.App.Sandbox(@remote, 'com.topdan.ted'),
      new MobileRemote.App.Sandbox(@remote, 'com.topdan.railscasts'),
      new MobileRemote.App.Sandbox(@remote, 'com.topdan.revision3'),
      new MobileRemote.App.Sandbox(@remote, 'com.topdan.vimeo'),
      new MobileRemote.App.Sandbox(@remote, 'com.topdan.khanacademy'),
      new MobileRemote.App.Sandbox(@remote, 'com.topdan.penny-arcade'),
      new MobileRemote.App.Sandbox(@remote, 'com.topdan.my-damn-channel'),
    ]
  
  render: (request, response) =>
    doc = @remote.currentBrowser().contentDocument
    url = doc.location.href
    uri = new MobileRemote.URI(url)
    app = null
    body = null
    
    if MobileRemote.startsWith(url, 'about:')
      body = this.about.render(uri, request, response)
    else
      app = @findApp(uri, request, response)
      body = app.render(uri, request, response) if app
    
    body || @remote.pages.mouse.index(request, response)
  
  findApp: (uri, request, response) =>
    for app in @list
      return app if app.domains && app.domains.indexOf(uri.host) != -1
    null