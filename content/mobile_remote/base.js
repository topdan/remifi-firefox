(function() {
  var Base,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  Base = (function() {

    Base.name = 'Base';

    MobileRemote.Base = Base;

    function Base(env) {
      this.env = env;
      this.unload = __bind(this.unload, this);

      this.load = __bind(this.load, this);

      this.refresh = __bind(this.refresh, this);

      this.toggle = __bind(this.toggle, this);

      this.handleRequest = __bind(this.handleRequest, this);

      this.isRunning = __bind(this.isRunning, this);

      this.createSandbox = __bind(this.createSandbox, this);

      this.currentDocument = __bind(this.currentDocument, this);

      this.currentBrowser = __bind(this.currentBrowser, this);

      this.currentWindow = __bind(this.currentWindow, this);

      this.currentURL = __bind(this.currentURL, this);

      this.view = null;
      this.pages = {};
      this.pages.apps = new MobileRemote.Pages.Apps(this);
      this.pages.home = new MobileRemote.Pages.Home(this);
      this.pages.tabs = new MobileRemote.Pages.Tabs(this);
      this.pages.windows = new MobileRemote.Pages.Windows(this);
      this.pages.controls = new MobileRemote.Pages.Controls(this);
      this.pages.keyboard = new MobileRemote.Pages.Keyboard(this);
      this.pages.mouse = new MobileRemote.Pages.Mouse(this);
      this.pages.error = new MobileRemote.Pages.Error(this);
      this.pages.notFound = new MobileRemote.Pages.NotFound(this);
      this.pages.noBody = new MobileRemote.Pages.NoBody(this);
      this.pages.settings = new MobileRemote.Pages.Settings(this);
      this.pages.bookmarklets = new MobileRemote.Pages.Bookmarklets(this);
    }

    Base.prototype.currentURL = function() {
      return this.currentDocument().location.href;
    };

    Base.prototype.currentWindow = function() {
      var wm;
      wm = Components.classes["@mozilla.org/appshell/window-mediator;1"].getService(Components.interfaces.nsIWindowMediator);
      return wm.getMostRecentWindow("navigator:browser");
    };

    Base.prototype.currentBrowser = function() {
      return this.currentWindow().getBrowser();
    };

    Base.prototype.currentDocument = function() {
      return this.currentBrowser().contentDocument;
    };

    Base.prototype.createSandbox = function(url, options) {
      var browserX, browserY, sandbox, zepto;
      if (options === null) {
        options = {};
      }
      sandbox = Components.utils.Sandbox(content);
      if (options.zepto) {
        sandbox.window = this.currentBrowser().contentWindow;
        sandbox.document = this.currentBrowser().contentDocument;
        browserX = window.mozInnerScreenX;
        browserY = window.mozInnerScreenY;
        if (!window.fullScreen) {
          browserY += document.getElementById("navigator-toolbox").clientHeight;
        }
        zepto = this.env.fileContent('/apps/lib/zepto.js');
        Components.utils.evalInSandbox('navigator = {userAgent: "Mozilla/5.0 (Macintosh Intel Mac OS X 10.5 rv:11.0) Gecko/20100101 Firefox/11.0"}', sandbox);
        Components.utils.evalInSandbox("screen = {width: " + screen.width + ", height: " + screen.height + "}", sandbox);
        Components.utils.evalInSandbox("document.isFullscreen = " + (this.currentDocument().mobileRemoteFullscreen === true), sandbox);
        Components.utils.evalInSandbox("window.browserX = " + browserX + " ; window.browserY = " + browserY, sandbox);
        Components.utils.evalInSandbox(zepto, sandbox);
        Components.utils.evalInSandbox('$ = Zepto', sandbox);
      }
      return sandbox;
    };

    Base.prototype.isRunning = function() {
      return this.server.isRunning;
    };

    Base.prototype.handleRequest = function(request, response) {
      var controller;
      controller = new MobileRemote.Controller(this, request, response);
      return controller.process(request, response);
    };

    Base.prototype.toggle = function() {
      if (this.server.isRunning) {
        return this.unload();
      } else {
        return this.load();
      }
    };

    Base.prototype.refresh = function() {
      return this.view.toggle(this.isRunning());
    };

    Base.prototype.load = function() {
      this.server.start();
      return this.view.toggle(true);
    };

    Base.prototype.unload = function() {
      this.server.stop();
      return this.view.toggle(false);
    };

    return Base;

  })();

}).call(this);
