class Controls
  Remifi.Pages.Controls = Controls
  
  constructor: (@remote) ->
  
  render: (request, response) =>
    if request.path == '/controls/home.html'
      @home(request, response);

    else if request.path == '/controls/stop.html'
      @stop(request, response);

    else if request.path == '/controls/refresh.html'
      @refresh(request, response);

    else if request.path == '/controls/back.html'
      @back(request, response);

    else if request.path == '/controls/forward.html'
      @forward(request, response);

    else if request.path == '/controls/visit.html'
      @visit(request, response);

    else if request.path == '/controls/search.html'
      @search(request, response);

    else if request.path == '/controls/wait.html'
      @wait(request, response);

    else if request.path == '/controls/wait.js'
      @waitJS(request, response);
    
    else if request.path == '/controls/confirmExit.html'
      @confirmExit(request, response)
      
    else if request.path == '/controls/exit.html'
      @exit(request, response)

  home: (request, response) =>
    @remote.currentBrowser().goHome();
    @wait(request.params['url'], request, response);

  stop: (request, response) =>
    @remote.currentBrowser().stop();
    @remote.pages.sites.render(request, response);

  refresh: (request, response) =>
    doc = @remote.currentBrowser().contentDocument;
    doc.location.href = doc.location.href;
    @wait(request.params['url'], request, response);

  back: (request, response) =>
    @remote.currentBrowser().goBack();
    @wait(request.params['url'], request, response);

  forward: (request, response) =>
    @remote.currentBrowser().goForward();
    @wait(request.params['url'], request, response);

  visit: (request, response) =>
    url = @polishURL(request.params["url"]);
    try
      @remote.currentBrowser().contentDocument.location.href = url if url
    catch err
      return @remote.views (v) ->
        v.page 'controls', ->
          v.toolbar()
          v.error "Invalid URL: #{url}"
      
    @wait('/', request, response);

  search: (request, response) =>
    search = request.params["q"] || "";
    request.params.url = 'http://www.google.com/search?q=' + encodeURIComponent(search) + '&ie=utf-8&oe=utf-8&aq=t&rls=org.mozilla:en-US:official&client=firefox-a';
    @visit(request, response)

  wait: (url, request, response, options) =>
    options ||= {}
    
    @remote.views (v) ->
      v.page 'controls', ->
        v.toolbar({stop: true});

        v.template('/views/loading.html');
        
        waitCall = 'remifi.wait("' + url + '", {'
        waitCall += 'ms: ' + options.ms if options.ms
        waitCall += '});'
        v.out.push('<script type="text/javascript">$(function() { ' + waitCall + ' })</script>');

  polishURL: (url) =>
    if typeof url == "undefined" || url == null || url == ""
      null
    else if !Remifi.startsWith(url, 'http://') && !Remifi.startsWith(url, 'https://')
      "http://" + url
    else
      url

  isLoading: =>
    !(@remote.currentBrowser().webProgress.isLoadingDocument == false || @remote.currentDocument().remifiIsLoaded == true)

  waitJS: (request, response) =>
    url = request.params["url"]
    if @isLoading()
      'setTimeout(function() { remifi.waitUnlessStopped("' + url + '")}, 250);'
    else
      'remifi.show("' + url + '")'
  
  confirmExit: (request, response) =>
    @remote.views (v) ->
      v.page 'confirmExit', ->
        v.toolbar()
        
        v.info 'Are you are your want to close your browser?'
        
        v.button 'Yes', '/controls/exit.html', type: 'primary'
        v.button 'No', '/home.html'
  
  exit: (request, response) =>
    app = Components.classes['@mozilla.org/toolkit/app-startup;1'].getService(Components.interfaces.nsIAppStartup)
    app.quit(Components.interfaces.nsIAppStartup.eForceQuit)
    
    @remote.views (v) ->
      v.page 'controls', ->
        v.toolbar()
        
        v.important 'Closing your browser'
        
        v.info 'Thanks for using Remifi!'
        

