class Windows
  Remifi.Pages.Windows = Windows
  
  constructor: (@remote) ->
  
  render: (request, response) =>
    if request.path == '/windows/index.html' || request.path == '/windows/'
      @index(request, response);
      
    else if request.path == '/windows/open.html'
      @open(request, response);
      
    else if request.path == '/windows/add.html'
      @add(request, response);
      
    else if request.path == '/windows/close.html'
      @close(request, response);

  index: (request, response) =>
    @remote.pages.tabs.index(request, response);

  open: (request, response) =>
    index = parseInt(request.params["index"]);
    unless isNaN(index)
      wm = Components.classes["@mozilla.org/appshell/window-mediator;1"].getService(Components.interfaces.nsIWindowMediator);
      wenum = wm.getEnumerator(null);
      count = 0
      loop 
        break unless wenum.hasMoreElements()
        win = wenum.getNext();
        win.focus() if index == count
        count++

    @remote.pages.sites.render(request, response);

  add: (request, response) =>
    # window.open("chrome://to/your/window.xul", windowName, "features");
    url = null;
    url = @remote.pages.controls.polishURL(request.params["url"]) if request.params["url"]

    if url
      window.open(url);
    else
      window.open();

    @remote.pages.sites.render(request, response);

  close: (request, response) =>
    index = parseInt(request.params["index"]);
    unless isNaN(index)
      wenum = Components.classes["@mozilla.org/embedcomp/window-watcher;1"].getService(Components.interfaces.nsIWindowWatcher).getWindowEnumerator();
      count = 0;
      loop 
        break unless wenum.hasMoreElements()
        win = wenum.getNext();
        if index == count && (!win.Remifi || win.Remifi.isReference == true)
          win.close();
        count++
    
    @index(request, response)
