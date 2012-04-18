(function() {
  var View, firstRunPref,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  View = (function() {

    View.name = 'View';

    MobileRemote.Firefox.View = View;

    function View() {
      this.install = __bind(this.install, this);

      this.toggle = __bind(this.toggle, this);

    }

    View.prototype.toggle = function(isOn) {
      var button, klass, wenum, win, wm, _results;
      klass = null;
      if (isOn) {
        klass = "toolbarbutton-1 chromeclass-toolbar-additional mobile-remote-button on";
      } else {
        klass = "toolbarbutton-1 chromeclass-toolbar-additional mobile-remote-button off";
      }
      wm = Components.classes["@mozilla.org/appshell/window-mediator;1"].getService(Components.interfaces.nsIWindowMediator);
      wenum = wm.getEnumerator(null);
      _results = [];
      while (true) {
        if (!wenum.hasMoreElements()) {
          break;
        }
        win = wenum.getNext();
        button = win.document.getElementById('mobile-remote-button');
        if (button) {
          _results.push(button.setAttribute('class', klass));
        } else {
          _results.push(void 0);
        }
      }
      return _results;
    };

    View.prototype.install = function(toolbarId, id, afterId) {
      var before, elem, toolbar;
      if (!document.getElementById(id)) {
        toolbar = document.getElementById(toolbarId);
        before = null;
        if (afterId) {
          elem = document.getElementById(afterId);
          if (elem && elem.parentNode === toolbar) {
            before = elem.nextElementSibling;
          }
        }
        toolbar.insertItem(id, before);
        toolbar.setAttribute("currentset", toolbar.currentSet);
        document.persist(toolbar.id, "currentset");
        if (toolbarId === "addon-bar") {
          return toolbar.collapsed = false;
        }
      }
    };

    return View;

  })();

  firstRunPref = "extensions.mobile-remote.firstRunDone";

  if (!Application.prefs.getValue(firstRunPref, false)) {
    Application.prefs.setValue(firstRunPref, true);
    this.install("nav-bar", "mobile-remote-button", "home-button");
  }

}).call(this);
