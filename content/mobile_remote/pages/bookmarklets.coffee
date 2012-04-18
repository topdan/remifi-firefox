class Bookmarklets
  MobileRemote.Pages.Bookmarklets = Bookmarklets
  
  constructor: (@remote) ->
  
  render: (request, response) =>
    if request.path == '/bookmarklets/index.html' || request.path == '/bookmarklets/'
      return @index(request, response)
      
    else if request.path == '/bookmarklets/new-tab.html'
      return @newTab(request, response)
      
    else if request.path == '/bookmarklets/new-window.html'
      return @newWindow(request, response)
      
    else if request.path == '/bookmarklets/visit.html'
      @visit(request, response)
    
  index: (request, response) =>
    @remote.views (v) ->
      v.page 'bookmarklets-page', ->
        v.toolbar();
        v.title("Bookmarklets");

        referer = request.headers["Referer"];
        referer = referer.match('(http://[^\/]+)')[0];
        viewJS = "javascript:document.location = '#{referer}/bookmarklets/visit.html?url=' + encodeURIComponent(document.location.href);";
        newTab = "javascript:document.location = '#{referer}/bookmarklets/new-tab.html?url=' + encodeURIComponent(document.location.href);";
        newWindow = "javascript:document.location = '#{referer}/bookmarklets/new-window.html?url=' + encodeURIComponent(document.location.href);";

        v.template('/views/bookmarklets.html', {viewJS: viewJS, newTab: newTab, newWindow: newWindow});

  visit: (request, response) =>
    @remote.pages.controls.visit(request, response);
    @remote.pages.controls.wait('/', request, response)

  newTab: (request, response) =>
    @remote.pages.tabs.add(request, response);
    @remote.pages.controls.wait('/', request, response);

  newWindow: (request, response) =>
    @remote.pages.windows.add(request, response);
    @remote.pages.controls.wait('/', request, response);
