class Apps
  Remifi.Pages.Apps = Apps
  
  constructor: (@remote) ->
    @about = new Remifi.App.About(@remote)
    @localhost = new Remifi.App.LocalHost(@remote)
    
    @list = [
      new Remifi.App.Sandbox(@remote, 'com.topdan.google'),
      new Remifi.App.Sandbox(@remote, 'com.topdan.youtube'),
      new Remifi.App.Sandbox(@remote, 'com.topdan.netflix'),
      new Remifi.App.Sandbox(@remote, 'com.topdan.hulu'),
      new Remifi.App.Sandbox(@remote, 'com.topdan.hbo'),
      new Remifi.App.Sandbox(@remote, 'com.topdan.cinemax'),
      new Remifi.App.Sandbox(@remote, 'com.topdan.reddit'),
      new Remifi.App.Sandbox(@remote, 'com.topdan.southparkstudios'),
      new Remifi.App.Sandbox(@remote, 'com.topdan.ted'),
      new Remifi.App.Sandbox(@remote, 'com.topdan.railscasts'),
      new Remifi.App.Sandbox(@remote, 'com.topdan.revision3'),
      new Remifi.App.Sandbox(@remote, 'com.topdan.vimeo'),
      new Remifi.App.Sandbox(@remote, 'com.topdan.khanacademy'),
      new Remifi.App.Sandbox(@remote, 'com.topdan.penny-arcade'),
      new Remifi.App.Sandbox(@remote, 'com.topdan.my-damn-channel'),
      new Remifi.App.Sandbox(@remote, 'com.topdan.grooveshark'),
    ]
  
  render: (request, response) =>
    doc = @remote.currentBrowser().contentDocument
    url = doc.location.href
    uri = new Remifi.URI(url)
    app = null
    body = null
    
    if Remifi.startsWith(url, 'about:')
      body = this.about.render(uri, request, response)
      
    else if (uri.host == 'localhost' || uri.host == '127.0.0.1') && uri.port == @remote.port.toString()
      body = this.localhost.render(uri, request, response)
      
    else
      app = @findApp(uri, request, response)
      body = app.render(uri, request, response) if app
    
    body || @remote.pages.mouse.index(request, response)
  
  findApp: (uri, request, response) =>
    for app in @list
      return app if app.domains && app.domains.indexOf(uri.host) != -1
    null