if (MobileRemote.Firefox == null) MobileRemote.Firefox = {}

MobileRemote.Firefox.View = function() {
  var self = this;
  
  this.toggle = function(isOn) {
    var klass = null;
    var button = document.getElementById('mobile-remote-button');
    
    // TODO DRY class
    if (isOn) {
      klass = "toolbarbutton-1 chromeclass-toolbar-additional mobile-remote-button on";
    } else {
      klass = "toolbarbutton-1 chromeclass-toolbar-additional mobile-remote-button off";
    }
    
    button.setAttribute('class', klass);
  }
  
}