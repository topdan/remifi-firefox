class View
  Remifi.Firefox.View = View
  
  constructor: () ->
  
  toggle: (isOn) =>
    klass = null
    
    # TODO DRY class
    if isOn
      klass = "toolbarbutton-1 chromeclass-toolbar-additional remifi-button on"
    else
      klass = "toolbarbutton-1 chromeclass-toolbar-additional remifi-button off"
    
    wm = Components.classes["@mozilla.org/appshell/window-mediator;1"].getService(Components.interfaces.nsIWindowMediator)
    wenum = wm.getEnumerator(null);
    loop
      break unless wenum.hasMoreElements()
      
      win = wenum.getNext()
      button = win.document.getElementById('remifi-button')
      button.setAttribute('class', klass) if button
  
  installButton: (toolbarId, buttonId, afterId) =>
    return if document.getElementById(buttonId)
    toolbar = document.getElementById(toolbarId)

    # If no afterId is given, then append the item to the toolbar
    before = null
    if afterId
      elem = document.getElementById(afterId)
      if elem && elem.parentNode == toolbar
        before = elem.nextElementSibling

    toolbar.insertItem(buttonId, before)
    toolbar.setAttribute("currentset", toolbar.currentSet)
    document.persist(toolbar.id, "currentset")

    toolbar.collapsed = false if toolbarId == "addon-bar"
