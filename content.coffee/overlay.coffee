# the extension's namespace
window.Remifi = {};

class Overlay
  Remifi.Site = {};
  Remifi.Firefox = {};
  Remifi.Firefox.Input = {};
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
