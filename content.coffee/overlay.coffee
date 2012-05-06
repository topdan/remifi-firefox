# the extension's namespace
window.Remifi = {};

class Overlay
  Remifi.App = {};
  Remifi.Firefox = {};
  Remifi.Pages = {};
  Remifi.Util = {};
  Remifi.Views = {};

onLoad = (e) ->
  boot = new Remifi.Firefox.Boot()
  boot.load()
  
unLoad = (e) ->
  boot = new Remifi.Firefox.Boot()
  boot.unload()

window.addEventListener "load", onLoad, false
window.addEventListener "unload", unLoad, false
