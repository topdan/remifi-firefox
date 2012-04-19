class View
  MobileRemote.Firefox.View = View
  
  constructor: () ->
  
  toggle: (isOn) =>
    klass = null
    
    # TODO DRY class
    if isOn
      klass = "toolbarbutton-1 chromeclass-toolbar-additional mobile-remote-button on"
    else
      klass = "toolbarbutton-1 chromeclass-toolbar-additional mobile-remote-button off"
    
    wm = Components.classes["@mozilla.org/appshell/window-mediator;1"].getService(Components.interfaces.nsIWindowMediator)
    wenum = wm.getEnumerator(null);
    loop
      break unless wenum.hasMoreElements()
      
      win = wenum.getNext()
      button = win.document.getElementById('mobile-remote-button')
      button.setAttribute('class', klass) if button
  
  install: (toolbarId, id, afterId) =>
    unless document.getElementById(id)
      toolbar = document.getElementById(toolbarId)
      
      # If no afterId is given, then append the item to the toolbar
      before = null
      if afterId
        elem = document.getElementById(afterId)
        if elem && elem.parentNode == toolbar
          before = elem.nextElementSibling
      
      toolbar.insertItem(id, before)
      toolbar.setAttribute("currentset", toolbar.currentSet)
      document.persist(toolbar.id, "currentset")
      
      if (toolbarId == "addon-bar")
        toolbar.collapsed = false

firstRunPref = "extensions.mobile-remote.firstRunDone";
unless Application.prefs.getValue(firstRunPref, false)
  Application.prefs.setValue(firstRunPref, true)
  this.install("nav-bar", "mobile-remote-button", "home-button")

