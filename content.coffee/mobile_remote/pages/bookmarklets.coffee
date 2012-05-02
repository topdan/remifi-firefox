class Bookmarklets
  MobileRemote.Pages.Bookmarklets = Bookmarklets
  
  constructor: (@remote) ->
  
  render: (request, response) =>
    if request.path == '/bookmarklets/index.html' || request.path == '/bookmarklets/'
      return @index(request, response)
      
    else if request.path == '/bookmarklets/new-tab.html'
      return @newTab(request, response)
      
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
        v.br()
        v.button("Back to Settings", '/settings/index.html')

  visit: (request, response) =>
    @convertMobileURL(request)
    @remote.pages.controls.visit(request, response);
    @remote.pages.controls.wait('/', request, response)

  newTab: (request, response) =>
    @convertMobileURL(request)
    @remote.pages.tabs.add(request, response);
    @remote.pages.controls.wait('/', request, response);

  convertMobileURL: (request) =>
    url = request.params.url
    return unless url
    
    if url.indexOf('://m.') != -1
      request.params.url = url.replace('://m.', '://')