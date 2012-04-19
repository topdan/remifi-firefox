(function() {
  var Settings,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  Settings = (function() {

    Settings.name = 'Settings';

    MobileRemote.Pages.Settings = Settings;

    function Settings(remote) {
      this.remote = remote;
      this.about = __bind(this.about, this);

      this.update = __bind(this.update, this);

      this.fullscreen = __bind(this.fullscreen, this);

      this.index = __bind(this.index, this);

      this.render = __bind(this.render, this);

      this.version = this.remote.env.fileContent('/content/VERSION');
      this.xpiPath = "http://mobile-remote.topdan.com.s3.amazonaws.com/mobile-remote-edge.xpi";
    }

    Settings.prototype.render = function(request, response) {
      if (request.path === '/settings/index.html' || request.path === '/settings/') {
        return this.index(request, response);
      } else if (request.path === '/settings/about.html') {
        return this.about(request, response);
      } else if (request.path === '/settings/update.html') {
        return this.update(request, response);
      } else if (request.path === '/settings/fullscreen.html') {
        return this.fullscreen(request, response);
      }
    };

    Settings.prototype.index = function(request, response) {
      return this.remote.views(function(v) {
        return v.page('settings', function() {
          v.toolbar();
          v.title("Settings");
          v.list([
            {
              title: "Bookmarklets",
              url: "/bookmarklets/"
            }, {
              title: "About Me",
              url: "/settings/about.html"
            }
          ]);
          v.button('Check for Updates', '/settings/update.html');
          if (window.fullScreen) {
            return v.button('Turn fullscreen off', '/settings/fullscreen.html');
          } else {
            return v.button('Turn fullscreen on', '/settings/fullscreen.html');
          }
        });
      });
    };

    Settings.prototype.fullscreen = function(request, response) {
      window.fullScreen = !window.fullScreen;
      return this.index(request, response);
    };

    Settings.prototype.update = function(request, response) {
      return this.remote.views(function(v) {
        return v.page('update', function() {
          v.toolbar();
          v.title("System Update");
          request = new XMLHttpRequest();
          request.open('GET', 'http://mobile-remote.topdan.com/EDGE-VERSION', false);
          request.send(null);
          if (request.status !== 200) {
            return v.error("Could not talk to the update server. Please try again later");
          } else if (request.responseText === remote.version) {
            v.info("You have the most up-to-date version of the mobile remote");
            v.br();
            return v.button("Back to Settings", '/settings/index.html', {
              type: 'primary'
            });
          } else {
            v.info("There is an updated version of the mobile remote. Use the mouse app to agree to install the new version when the download is finished.");
            v.br();
            return v.button("Get the Update", '/controls/visit.html?url=' + encodeURIComponent(this.xpiPath), {
              type: "primary"
            });
          }
        });
      });
    };

    Settings.prototype.about = function(request, response) {
      return this.remote.views(function(v) {
        return v.page('about_me', function() {
          v.toolbar();
          v.title("About Me");
          return v.list([
            {
              title: "Created By Dan Cunning"
            }, {
              title: "Follow @itopdan",
              url: "http://www.twitter.com/itopdan"
            }, {
              title: "Version: 0.1"
            }
          ]);
        });
      });
    };

    return Settings;

  })();

}).call(this);
