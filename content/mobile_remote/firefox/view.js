if (MobileRemote.Firefox == null) MobileRemote.Firefox = {}

MobileRemote.Firefox.View = function() {
  var self = this;
  
  this.toggle = function(isOn) {
    var klass = null;
    
    // TODO DRY class
    if (isOn) {
      klass = "toolbarbutton-1 chromeclass-toolbar-additional mobile-remote-button on";
    } else {
      klass = "toolbarbutton-1 chromeclass-toolbar-additional mobile-remote-button off";
    }
    
    var wm = Components.classes["@mozilla.org/appshell/window-mediator;1"].getService(Components.interfaces.nsIWindowMediator);
    var wenum = wm.getEnumerator(null);
    while (wenum.hasMoreElements()) {
      var win = wenum.getNext();
      var button = win.document.getElementById('mobile-remote-button');
      if (button)
        button.setAttribute('class', klass);
    }
  }
  
  this.install = function(toolbarId, id, afterId) {
    if (!document.getElementById(id)) {
      var toolbar = document.getElementById(toolbarId);
      
      // If no afterId is given, then append the item to the toolbar
      var before = null;
      if (afterId) {
        var elem = document.getElementById(afterId);
        if (elem && elem.parentNode == toolbar)
          before = elem.nextElementSibling;
      }
      
      toolbar.insertItem(id, before);
      toolbar.setAttribute("currentset", toolbar.currentSet);
      document.persist(toolbar.id, "currentset");
      
      if (toolbarId == "addon-bar")
        toolbar.collapsed = false;
    }
  }
  
  var firstRunPref = "extensions.mobile-remote.firstRunDone";
  if (!Application.prefs.getValue(firstRunPref, false)) {
    Application.prefs.setValue(firstRunPref, true);
    this.install("nav-bar", "mobile-remote-button", "home-button");
  }
  
}