class Sites
  Remifi.Pages.Sites = Sites
  
  constructor: (@remote) ->
    @about = new Remifi.Site.About(@remote)
    @localhost = new Remifi.Site.LocalHost(@remote)
    
  readSites: =>
    return @cachedSites if @cachedSites
    
    Components.utils.reportError 'reading sites'
    sites = []
    @remote.env.eachFile '/sites', (path) =>
      site = new Remifi.Site.Sandbox(@remote, "/sites#{path}")
      sites.push site if site.domains && site.domains.length > 0
    
    @cachedSites = sites unless @remote.env.isDevMode
    
    sites
  
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
    for site in @readSites()
      return site if site.domains && site.domains.indexOf(uri.host) != -1
    null