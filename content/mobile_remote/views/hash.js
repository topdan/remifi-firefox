(function() {
  var Hash,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  Hash = (function() {
    var FormTypes, PageTypes;

    Hash.name = 'Hash';

    MobileRemote.Views.Hash = Hash;

    function Hash(app, request, response) {
      this.app = app;
      this.request = request;
      this.response = response;
      this.actionUrlFor = __bind(this.actionUrlFor, this);

      this.performArray = __bind(this.performArray, this);

      this.perform = __bind(this.perform, this);

      this.pageCount = 0;
      this.view = null;
      this.pageTypes = new PageTypes(this);
      this.formTypes = new FormTypes(this);
    }

    Hash.prototype.perform = function(items) {
      var p, type;
      type = items.type;
      if (type === 'wait') {
        return this.app.remote.pages.controls.wait('/', this.request, this.response);
      } else if (type === 'pages' && typeof items.content === "object" && items.content.length > 0) {
        p = this;
        return this.app.remote.views(function(v) {
          p.view = v;
          return p.performArray(items.content, p.pageTypes);
        });
      }
    };

    Hash.prototype.performArray = function(array, types) {
      var convert, item, type, _i, _len, _results;
      _results = [];
      for (_i = 0, _len = array.length; _i < _len; _i++) {
        item = array[_i];
        if (typeof item === "object") {
          type = item["type"];
          convert = types[type];
          if (typeof convert === "function") {
            _results.push(convert(item));
          } else {
            _results.push(void 0);
          }
        } else {
          _results.push(void 0);
        }
      }
      return _results;
    };

    Hash.prototype.actionUrlFor = function(action) {
      if (action === null) {
        return null;
      } else if (MobileRemote.startsWith(action, 'http://') || MobileRemote.startsWith(action, 'https://') || MobileRemote.startsWith(action, '/')) {
        return action;
      } else {
        return '/apps/' + this.app.name + '/' + action;
      }
    };

    PageTypes = (function() {

      PageTypes.name = 'PageTypes';

      function PageTypes(p) {
        this.p = p;
        this.systemApps = __bind(this.systemApps, this);

        this.apps = __bind(this.apps, this);

        this.list = __bind(this.list, this);

        this.paginate = __bind(this.paginate, this);

        this.error = __bind(this.error, this);

        this.form = __bind(this.form, this);

        this.br = __bind(this.br, this);

        this.fullscreen = __bind(this.fullscreen, this);

        this.keyboard = __bind(this.keyboard, this);

        this.mouse = __bind(this.mouse, this);

        this.button = __bind(this.button, this);

        this.title = __bind(this.title, this);

        this.toolbar = __bind(this.toolbar, this);

        this.page = __bind(this.page, this);

      }

      PageTypes.prototype.page = function(hash) {
        var id, p;
        this.p.pageCount++;
        id = hash.id || "app-page-" + this.p.pageCount;
        p = this.p;
        return this.p.view.page(id, function() {
          if (hash.content) {
            return p.performArray(hash.content, p.pageTypes);
          }
        });
      };

      PageTypes.prototype.toolbar = function(hash) {
        return this.p.view.toolbar();
      };

      PageTypes.prototype.title = function(hash) {
        return this.p.view.title(hash.name);
      };

      PageTypes.prototype.button = function(hash) {
        var url;
        url = this.p.actionUrlFor(hash.url);
        return this.p.view.button(hash.name, url, {
          type: hash.buttonType,
          disabled: hash.disabled
        });
      };

      PageTypes.prototype.mouse = function(hash) {
        var action, delay, x, y;
        action = hash.action;
        delay = hash.delay;
        x = hash.x;
        y = Math.max(hash.y, 25);
        switch (action) {
          case 'click':
            return this.p.app.remote.pages.mouse.action('click', delay, x, y);
          case 'over':
            return this.p.app.remote.pages.mouse.action('over', delay, x, y);
        }
      };

      PageTypes.prototype.keyboard = function(hash) {
        var action, key;
        action = hash.action;
        key = hash.key;
        switch (action) {
          case 'press':
            return this.p.app.remote.pages.keyboard.press(hash.key);
        }
      };

      PageTypes.prototype.fullscreen = function(hash) {
        return this.p.app.remote.currentDocument().mobileRemoteFullscreen = hash.value === true;
      };

      PageTypes.prototype.br = function(hash) {
        return this.p.view.br();
      };

      PageTypes.prototype.form = function(hash) {
        var p, url;
        if (this.currentForm) {
          return;
        }
        url = this.p.actionUrlFor(hash.action);
        p = this.p;
        return this.p.view.form(url, function(f) {
          p.currentForm = f;
          if (hash.content) {
            p.performArray(hash.content, p.formTypes);
          }
          return p.currentForm = null;
        });
      };

      PageTypes.prototype.error = function(hash) {
        return this.p.view.error(hash.text);
      };

      PageTypes.prototype.paginate = function(hash) {
        var item, _i, _len, _ref;
        _ref = hash.items;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          item = _ref[_i];
          item.url = this.p.actionUrlFor(item.url);
        }
        return this.p.view.paginate(hash.items);
      };

      PageTypes.prototype.list = function(hash) {
        var item, _i, _len, _ref;
        _ref = hash.items;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          item = _ref[_i];
          item.url = this.p.actionUrlFor(item.url);
        }
        return this.p.view.list(hash.items, {
          rounded: hash.rounded
        });
      };

      PageTypes.prototype.apps = function(hash) {};

      PageTypes.prototype.systemApps = function(hash) {};

      return PageTypes;

    })();

    FormTypes = (function() {

      FormTypes.name = 'FormTypes';

      function FormTypes(p) {
        this.p = p;
        this.submit = __bind(this.submit, this);

        this.search = __bind(this.search, this);

        this.url = __bind(this.url, this);

        this.br = __bind(this.br, this);

        this.fieldset = __bind(this.fieldset, this);

      }

      FormTypes.prototype.fieldset = function(hash) {
        var p;
        p = this.p;
        return this.p.currentForm.fieldset(function() {
          if (hash.content) {
            return p.performArray(hash.content, p.formTypes);
          }
        });
      };

      FormTypes.prototype.br = function(hash) {
        return this.p.currentForm.br();
      };

      FormTypes.prototype.url = function(hash) {
        return this.p.currentForm.url(hash.name, {
          placeholder: hash.placeholder,
          value: hash.value
        });
      };

      FormTypes.prototype.search = function(hash) {
        return this.p.currentForm.search(hash.name, {
          placeholder: hash.placeholder,
          value: hash.value
        });
      };

      FormTypes.prototype.submit = function(hash) {
        var url;
        url = '#';
        return this.p.currentForm.submit(hash.name, url, {
          placeholder: hash.placeholder,
          value: hash.value
        });
      };

      return FormTypes;

    })();

    return Hash;

  }).call(this);

}).call(this);
