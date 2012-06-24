class Controller
  Remifi.Controller = Controller
  
  constructor: (@remote) ->
    @layout = null
    @firstSplashPref = 'extensions.remifi.firstRemoteSplash'
    @firstSplash = Application.prefs.getValue(@firstSplashPref, false)
  
  process: (request, response) =>
    doc = @remote.currentBrowser().contentDocument
    uri = new Remifi.URI(doc.location.href)
    
    page = @findPage(request)
    body = null
    
    try
      if !@firstSplash
        @firstSplash = true
        Application.prefs.setValue(@firstSplashPref, true)
        
        body = @remote.pages.sites.localhost.gettingStarted(uri, request, response)
      else
        body = page.render(request, response)
    catch err
      doc.remifiError = err
      Components.utils.reportError(err)
      body = @remote.pages.error.render(err, request, response)
    
    body ||= @remote.pages.noBody.render(request, response)
    
    if page && page != @remote.pages.notFound && !response.skipFullscreenCheck
      @ensureFullscreenMode()
    
    if request.isXhr && (request.isScript || request.isJSON) || response.isRedirect
      body
    else if request.isXhr
      # we're ripping data from rendered HTML, it has weird characters when transferring via defaults
      response.headers["Content-Type"] = "text/html; charset=ISO-8859-1"
      
      body + '<script type="text/javascript" charset="utf-8">\nsetupPages()\n</script>'
    else if response.noLayout
      body
      
    else
      @withLayout(body)
  
  findPage: (request) =>
    if request.path == "/home.html"
      @remote.pages.home;
    else if request.path == "/" || Remifi.startsWith(request.path, '/sites/')
      @remote.pages.sites;
    else if Remifi.startsWith(request.path, '/tabs/')
      @remote.pages.tabs;
    else if Remifi.startsWith(request.path, '/windows/')
      @remote.pages.windows;
    else if Remifi.startsWith(request.path, '/controls/')
      @remote.pages.controls;
    else if Remifi.startsWith(request.path, '/mouse/')
      @remote.pages.mouse;
    else if Remifi.startsWith(request.path, '/keyboard/')
      @remote.pages.keyboard;
    else if Remifi.startsWith(request.path, '/bookmarklets/')
      @remote.pages.bookmarklets;
    else if Remifi.startsWith(request.path, '/settings/')
      @remote.pages.settings;
    else if Remifi.startsWith(request.path, '/getting-started/')
      @remote.pages.gettingStarted;
    else
      @remote.pages.notFound;
  
  withLayout: (body) =>
    if @layout == null
      code = @remote.env.fileContent('/views/layout.html');
      if code == null
        throw "/views/layout.html was not found"
      @layout = Remifi.microtemplate(code)
    
    views = new Remifi.Views.Base(@remote.env);
    @layout({body: body, views: views, urlFor: @remote.static.urlFor});
  
  ensureFullscreenMode: () =>
    return if @remote.env.isDevMode
    
    autoFullscreenOff = Application.prefs.getValue('extensions.remifi.autoFullscreenOff', false)
    return if autoFullscreenOff
    
    window.fullScreen = true