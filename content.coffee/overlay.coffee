# the extension's namespace
window.MobileRemote = {};

class Overlay
  MobileRemote.App = {};
  MobileRemote.Firefox = {};
  MobileRemote.Pages = {};
  MobileRemote.Util = {};
  MobileRemote.Views = {};

onLoad = (e) ->
  boot = new MobileRemote.Firefox.Boot()
  boot.load()
  
unLoad = (e) ->
  boot = new MobileRemote.Firefox.Boot()
  boot.unload()

window.addEventListener "load", onLoad, false
window.addEventListener "unload", unLoad, false
