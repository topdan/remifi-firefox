class Tabs
  MobileRemote.Pages.Tabs = Tabs
  
  constructor: (@remote) ->
  
  render: (request, response) =>
    if request.path == '/tabs/index.html' || request.path == '/tabs/'
      @index(request, response);

    else if request.path == '/tabs/open.html'
      @open(request, response);

    else if request.path == '/tabs/add.html'
      @add(request, response);

    else if request.path == '/tabs/close.html'
      @close(request, response);

  open: (request, response) =>
    index = request.params["index"];
    @remote.currentBrowser().selectTabAtIndex(index) if index
    @remote.pages.apps.render(request, response);

  add: (request, response) =>
    url = @remote.pages.controls.polishURL(request.params["url"]) || "";
    gBrowser.selectedTab = @remote.currentBrowser().addTab(url);
    @remote.pages.apps.render(request, response);

  close: (request, response) =>
    currentWindow = @remote.currentWindow();
    currentBrowser = @remote.currentBrowser();
    index = request.params['index'];
    
    if index && (currentBrowser.mTabs.length > 1 || currentWindow.MobileRemote.isReference == true)
      tab = @remote.currentBrowser().mTabs[index];
      @remote.currentBrowser().removeTab(tab) if tab
    
    @index(request, response);

  index: (request, response) =>
    tabsList = @tabsList
    windowsList = @windowsList
    remote = @remote
    
    @remote.views (v) ->
      v.page 'tabs', ->
        v.toolbar();
        tabsList(v);
        windowsList(v);

        v.br();
        v.button('Open on Mobile', remote.currentURL(), {openLocally: true});
        v.button('New Tab', '/tabs/add.html');
        v.button('New Window', '/windows/add.html');

  tabsList: (v) =>
    currentWindow = @remote.currentWindow();
    currentBrowser = @remote.currentBrowser();
    currentTabIndex = null;
    tabs = []
    i = -1
    for tab in currentBrowser.mTabs
      i++
      browser = currentBrowser.getBrowserForTab(tab);

      currentTabIndex = i if tab == currentBrowser.mCurrentTab

      actions = null;
      if currentBrowser.mTabs.length > 1 || currentWindow.MobileRemote.isReference == true
        actions = [{title: 'close', url: '/tabs/close.html?index=' + i}]
      else
        actions = [{title: "can't close last tab", url: '/tabs/index.html'}]

      tabs.push({
        title: browser.contentDocument.title || "(Untitled)",
        url: '/tabs/open.html?index=' + i,
        active: (tab == currentBrowser.mCurrentTab),
        actions: actions
      })

    v.title("Tabs");
    v.list(tabs);

  windowsList: (v) =>
    currentWindowIndex = null;
    orderedWindows = Components.classes["@mozilla.org/appshell/window-mediator;1"].getService(Components.interfaces.nsIWindowMediator);
    currentWindow = orderedWindows.getZOrderDOMWindowEnumerator(null, true).getNext();

    windows = [];
    wenum = Components.classes["@mozilla.org/embedcomp/window-watcher;1"].getService(Components.interfaces.nsIWindowWatcher).getWindowEnumerator();
    count = 0;
    loop
      break unless wenum.hasMoreElements()
      win = wenum.getNext();

      actions = null;
      if count == 0
        actions = [{
          title: "can't close main window",
          url: '/windows/index.html'
        }]
      else
        actions = [{
          title: 'close',
          url: '/windows/close.html?index=' + count
        }]

      if currentWindow == win && win.MobileRemote.isReference == true
        currentWindowIndex = count

      windows.push({
        title: win.name || win.document.title || "(Untitled)",
        url: '/windows/open.html?index=' + count,
        actions: actions,
        active: (currentWindow == win)
      })

      count++;

    v.title("Windows");
    v.list(windows);
