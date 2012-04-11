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
  
}