(function() {
  var Request,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  Request = (function() {

    Request.name = 'Request';

    MobileRemote.Request = Request;

    function Request() {
      this.cleanPath = __bind(this.cleanPath, this);

      this.setPath = __bind(this.setPath, this);
      this.remote_ip = null;
      this.headers = {};
      this.fullpath = null;
      this.path = null;
      this.params = null;
    }

    Request.prototype.setPath = function(path) {
      var key, smoothPath, uri, value, _ref;
      this.fullpath = path;
      smoothPath = this.cleanPath(path);
      uri = new MobileRemote.URI("http://mobile-remote.topdan.com" + smoothPath);
      this.params = uri.queryKey;
      this.path = uri.path;
      this.isScript = MobileRemote.endsWith(this.path, '.js');
      if (this.params) {
        _ref = this.params;
        for (key in _ref) {
          value = _ref[key];
          this.params[key] = decodeURIComponent(value);
        }
      }
      return path;
    };

    Request.prototype.cleanPath = function(path) {
      return path.replace(/\+/g, '%20');
    };

    return Request;

  })();

}).call(this);
