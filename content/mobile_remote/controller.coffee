class Controller
  MobileRemote.Controller = Controller
  
  constructor: (@remote) ->
    @layout = null
  
  process: (request, response) =>
    doc = @remote.currentBrowser().contentDocument
    uri = new MobileRemote.URI(doc.location.href)
    
    page = @findPage(request)
    body = null
    
    try
      # if (page == @remote.pages.apps && doc.mobileRemoteError)
      #   body = @remote.pages.mouse.index(doc.mobileRemoteError, request, response)
      # else
        body = page.render(request, response)
    # catch err
    #   doc.mobileRemoteError = err
    #   Components.utils.reportError(err)
    #   body = @remote.pages.error.render(err, request, response)
    
    body ||= @remote.pages.noBody.render(request, response)
    
    
    if request.isXhr && request.isScript
      body
    else if request.isXhr
      # we're ripping data from rendered HTML, it has weird characters when transferring via defaults
      response.headers["Content-Type"] = "text/html; charset=ISO-8859-1"
      
      body + '<script type="text/javascript" charset="utf-8">\nsetupPages()\n</script>'
    else
      @withLayout(body)
  
  findPage: (request) =>
    if request.path == "/home.html"
      @remote.pages.home;
    else if request.path == "/" || MobileRemote.startsWith(request.path, '/apps/')
      @remote.pages.apps;
    else if MobileRemote.startsWith(request.path, '/tabs/')
      @remote.pages.tabs;
    else if MobileRemote.startsWith(request.path, '/windows/')
      @remote.pages.windows;
    else if MobileRemote.startsWith(request.path, '/controls/')
      @remote.pages.controls;
    else if MobileRemote.startsWith(request.path, '/mouse/')
      @remote.pages.mouse;
    else if MobileRemote.startsWith(request.path, '/keyboard/')
      @remote.pages.keyboard;
    else if MobileRemote.startsWith(request.path, '/bookmarklets/')
      @remote.pages.bookmarklets;
    else if MobileRemote.startsWith(request.path, '/settings/')
      @remote.pages.settings;
    else
      @remote.pages.notFound;
  
  withLayout: (body) =>
    if @layout == null
      code = @remote.env.fileContent('/views/layout.html');
      if code == null
        throw "/views/layout.html was not found"
      @layout = MobileRemote.microtemplate(code);
    
    views = new MobileRemote.Views.Base(@remote.env);
    @layout({body: body, views: views});
    