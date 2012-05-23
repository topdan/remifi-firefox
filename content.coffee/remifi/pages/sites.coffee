class Sites
  Remifi.Pages.Sites = Sites
  
  constructor: (@remote) ->
    @about = new Remifi.Site.About(@remote)
    @localhost = new Remifi.Site.LocalHost(@remote)
    
    @list = [
      new Remifi.Site.Sandbox(@remote, 'com.topdan.google'),
      new Remifi.Site.Sandbox(@remote, 'com.topdan.youtube'),
      new Remifi.Site.Sandbox(@remote, 'com.topdan.netflix'),
      new Remifi.Site.Sandbox(@remote, 'com.topdan.hulu'),
      new Remifi.Site.Sandbox(@remote, 'com.topdan.hbo'),
      new Remifi.Site.Sandbox(@remote, 'com.topdan.cinemax'),
      new Remifi.Site.Sandbox(@remote, 'com.topdan.reddit'),
      new Remifi.Site.Sandbox(@remote, 'com.topdan.southparkstudios'),
      new Remifi.Site.Sandbox(@remote, 'com.topdan.ted'),
      new Remifi.Site.Sandbox(@remote, 'com.topdan.railscasts'),
      new Remifi.Site.Sandbox(@remote, 'com.topdan.revision3'),
      new Remifi.Site.Sandbox(@remote, 'com.topdan.vimeo'),
      new Remifi.Site.Sandbox(@remote, 'com.topdan.khanacademy'),
      new Remifi.Site.Sandbox(@remote, 'com.topdan.penny-arcade'),
      new Remifi.Site.Sandbox(@remote, 'com.topdan.my-damn-channel'),
      new Remifi.Site.Sandbox(@remote, 'com.topdan.grooveshark'),
      new Remifi.Site.Sandbox(@remote, 'com.topdan.remifi'),
    ]
  
  render: (request, response) =>
    doc = @remote.currentBrowser().contentDocument
    url = doc.location.href
    uri = new Remifi.URI(url)
    site = null
    body = null
    
    if Remifi.startsWith(url, 'about:')
      body = this.about.render(uri, request, response)
      
    else if (uri.host == 'localhost' || uri.host == '127.0.0.1') && uri.port == @remote.port.toString()
      body = this.localhost.render(uri, request, response)
      
    else
      site = @findSite(uri, request, response)
      body = site.render(uri, request, response) if site
    
    body || @remote.pages.mouse.index(request, response)
  
  findSite: (uri, request, response) =>
    for site in @list
      return site if site.domains && site.domains.indexOf(uri.host) != -1
    null