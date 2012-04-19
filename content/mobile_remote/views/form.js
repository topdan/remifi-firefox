(function() {
  var Form,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  Form = (function() {

    Form.name = 'Form';

    MobileRemote.Views.Form = Form;

    function Form(view, env, formUrl, options) {
      this.view = view;
      this.env = env;
      this.formUrl = formUrl;
      this.options = options;
      this.input = __bind(this.input, this);

      this.submit = __bind(this.submit, this);

      this.search = __bind(this.search, this);

      this.url = __bind(this.url, this);

      this.br = __bind(this.br, this);

      this.fieldset = __bind(this.fieldset, this);

      this.escapeHTML = __bind(this.escapeHTML, this);

      this.escape = __bind(this.escape, this);

      this.html = __bind(this.html, this);

      this.options || (this.options = {});
      this.inFieldset = null;
      this.out = ['<form action="' + this.formUrl + '" method="GET">'];
    }

    Form.prototype.html = function() {
      this.out.push('</ul></form>');
      return this.out.join("");
    };

    Form.prototype.escape = function(string) {
      return MobileRemote.escape(string);
    };

    Form.prototype.escapeHTML = function(string) {
      return MobileRemote.escapeHTML(string);
    };

    Form.prototype.fieldset = function(callback) {
      this.out.push('<ul class="edit">');
      this.inFieldset = true;
      callback();
      this.inFieldset = false;
      return this.out.push('</ul>');
    };

    Form.prototype.br = function() {
      return this.out.push("<br/>");
    };

    Form.prototype.url = function(name, options) {
      return this.input('url', name, options);
    };

    Form.prototype.search = function(name, options) {
      return this.input('search', name, options);
    };

    Form.prototype.submit = function(name, url, options) {
      var klass;
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
      return this.out.push('<a class="submit ' + this.escape(klass) + '" href="' + this.escape(url) + '" style="">' + this.escapeHTML(name) + '</a>');
    };

    Form.prototype.input = function(type, name, options) {
      var code, rest;
      options || (options = {});
      rest = "";
      if (options.placeholder) {
        rest = rest + ' placeholder="' + this.escape(options.placeholder) + '"';
      }
      if (options.value) {
        rest = rest + ' value="' + this.escape(options.value) + '"';
      }
      code = '<input type="' + this.escape(type) + '" name="' + this.escape(name) + '"' + rest + '/>';
      if (this.inFieldset) {
        code = '<li>' + code + '</li>';
      }
      return this.out.push(code);
    };

    return Form;

  })();

}).call(this);
