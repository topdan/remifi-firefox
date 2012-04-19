(function() {
  var Base,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  Base = (function() {

    Base.name = 'Base';

    MobileRemote.Views.Base = Base;

    function Base(env) {
      this.env = env;
      this.systemApps = __bind(this.systemApps, this);

      this.apps = __bind(this.apps, this);

      this.list = __bind(this.list, this);

      this.paginate = __bind(this.paginate, this);

      this.info = __bind(this.info, this);

      this.error = __bind(this.error, this);

      this.form = __bind(this.form, this);

      this.br = __bind(this.br, this);

      this.button = __bind(this.button, this);

      this.title = __bind(this.title, this);

      this.toolbar = __bind(this.toolbar, this);

      this.page = __bind(this.page, this);

      this.externalURL = __bind(this.externalURL, this);

      this.escapeHTML = __bind(this.escapeHTML, this);

      this.escape = __bind(this.escape, this);

      this.template = __bind(this.template, this);

      this.safeOut = __bind(this.safeOut, this);

      this.html = __bind(this.html, this);

      this.out = [];
    }

    Base.prototype.html = function() {
      return this.out.join("");
    };

    Base.prototype.safeOut = function(s) {
      return this.out.push(s);
    };

    Base.prototype.template = function(path, data) {
      var code, func, html;
      data || (data = {});
      data.escape = this.escape;
      data.escapeHTML = this.escapeHTML;
      code = this.env.fileContent(path);
      if (code === null) {
        throw "viewpath not found: " + path;
      }
      func = MobileRemote.microtemplate(code);
      html = func(data);
      this.out.push(html);
      return html;
    };

    Base.prototype.escape = function(string) {
      return MobileRemote.escape(string);
    };

    Base.prototype.escapeHTML = function(string) {
      return MobileRemote.escapeHTML(string);
    };

    Base.prototype.externalURL = function(url) {
      return MobileRemote.startsWith(url, "http://") || MobileRemote.startsWith(url, "https://");
    };

    Base.prototype.page = function(id, callback) {
      this.out.push('<div id="' + id + '">');
      callback();
      return this.out.push('</div>');
    };

    Base.prototype.toolbar = function(options) {
      var right;
      options || (options = {});
      right = options.right || {
        title: 'home',
        url: '/home.html'
      };
      return this.template('/views/toolbar.html', {
        back: options.back,
        stop: options.stop,
        right: right
      });
    };

    Base.prototype.title = function(title) {
      return this.out.push('<h1>' + this.escapeHTML(title) + '</h1>');
    };

    Base.prototype.button = function(name, url, options) {
      var klass, rest;
      options || (options = {});
      klass = null;
      if (options.type === "info") {
        klass = "white";
      } else if (options.type === "danger") {
        klass = "redButton";
      } else if (options.type === "primary") {
        klass = "greenButton";
      } else {
        klass = "grayButton";
      }
      rest = 'class="' + this.escape(klass) + '"';
      if (typeof options.disabled === "string") {
        rest += ' href="#" data-disabled-message="' + options.disabled + '"';
      } else if (options.openLocally) {
        rest += ' target="_blank" href="' + this.escape(url) + '"';
      } else if (this.externalURL(url)) {
        rest += ' data-remote-url="' + this.escape(url) + '"';
      } else {
        rest += ' href="' + this.escape(url) + '"';
      }
      return this.out.push('<a ' + rest + '>' + this.escapeHTML(name) + '</a>');
    };

    Base.prototype.br = function() {
      return this.out.push("<br/>");
    };

    Base.prototype.form = function(url, callback) {
      var form;
      form = new MobileRemote.Views.Form(this, this.env, url);
      callback(form);
      return this.out.push(form.html());
    };

    Base.prototype.error = function(message) {
      return this.out.push('<p class="error-message">', this.escapeHTML(message), '</p>');
    };

    Base.prototype.info = function(message) {
      return this.out.push('<p class="info-message">', this.escapeHTML(message), '</p>');
    };

    Base.prototype.paginate = function(items) {
      var item, name, polished, remoteURL, url, _i, _len;
      polished = [];
      for (_i = 0, _len = items.length; _i < _len; _i++) {
        item = items[_i];
        if (item.name && item.url) {
          name = item.name;
          if (item.name === "prev") {
            if (items.length < 3) {
              name = "&laquo; Previous";
            } else {
              name = "&laquo;";
            }
          } else if (item.name === "next") {
            if (items.length < 3) {
              name = "Next &raquo;";
            } else {
              name = "&raquo;";
            }
          } else {
            name = this.escape(this.name);
          }
          if (this.externalURL(item.url)) {
            url = "#";
            remoteURL = item.url;
          } else {
            url = item.url;
            remoteURL = null;
          }
          polished.push({
            name: name,
            url: url,
            remoteURL: remoteURL
          });
        }
      }
      return this.template('/views/paginate.html', {
        items: polished
      });
    };

    Base.prototype.list = function(items, options) {
      options || (options = {});
      if (items === null || items.length === 0) {
        return;
      }
      return this.template("/views/list.html", {
        items: items,
        rounded: options.rounded
      });
    };

    Base.prototype.apps = function(apps, options) {
      var app, count, row, rows, _i, _len;
      options || (options = {});
      if (apps.length === 0) {
        return;
      }
      row = [];
      rows = [row];
      count = 0;
      for (_i = 0, _len = apps.length; _i < _len; _i++) {
        app = apps[_i];
        if (count === 4) {
          row = [];
          rows.push(row);
          count = 0;
        }
        if (app === null) {
          app = {
            isBlank: true,
            icon: {}
          };
        } else if (app.icon === null) {
          app.icon = {
            width: 60,
            height: 60,
            url: '/static/images/bhg.png'
          };
        } else if (app.icon === 'folder') {
          app.icon = {
            width: 60,
            height: 60,
            url: '/static/images/crystal_clear_icons/folder_grey_open.png'
          };
        }
        row.push(app);
        count++;
      }
      while (row.length < 4) {
        row.push({
          isBlank: true
        });
      }
      return this.template("/views/buttons.html", {
        rows: rows,
        tableId: options.tableId,
        tableClass: options.tableClass
      });
    };

    Base.prototype.systemApps = function(apps, options) {
      options || (options = {});
      options = MobileRemote.mergeHash(options, {
        tableClass: 'system-app-icons'
      });
      return this.apps(apps, options);
    };

    return Base;

  })();

}).call(this);
