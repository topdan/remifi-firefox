(function() {
  var URI,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  URI = (function() {

    URI.name = 'URI';

    MobileRemote.URI = URI;

    function URI(str) {
      var i, m, o, self;
      this.str = str;
      this.clone = __bind(this.clone, this);

      this.toString = __bind(this.toString, this);

      o = MobileRemote.parseUriOptions;
      i = 14;
      if (o.parser[o.strictMode]) {
        m = 'strict';
      } else {
        m = 'loose';
      }
      m = o.parser[m].exec(this.str);
      while (i--) {
        this[o.key[i]] = m[i] || "";
      }
      this[o.q.name] = {};
      self = this;
      this[o.key[12]].replace(o.q.parser, function($0, $1, $2) {
        if ($1) {
          return self[o.q.name][$1] = $2;
        }
      });
    }

    URI.prototype.toString = function() {
      return this.str;
    };

    URI.prototype.clone = function() {
      return MobileRemote.cloneHash(this);
    };

    return URI;

  })();

  MobileRemote.parseUriOptions = {
    strictMode: false,
    key: ["source", "protocol", "authority", "userInfo", "user", "password", "host", "port", "relative", "path", "directory", "file", "query", "anchor"],
    q: {
      name: "queryKey",
      parser: /(?:^|&)([^&=]*)=?([^&]*)/g
    },
    parser: {
      strict: /^(?:([^:\/?#]+):)?(?:\/\/((?:(([^:@]*)(?::([^:@]*))?)?@)?([^:\/?#]*)(?::(\d*))?))?((((?:[^?#\/]*\/)*)([^?#]*))(?:\?([^#]*))?(?:#(.*))?)/,
      loose: /^(?:(?![^:@]+:[^:@\/]*@)([^:\/?#.]+):)?(?:\/\/)?((?:(([^:@]*)(?::([^:@]*))?)?@)?([^:\/?#]*)(?::(\d*))?)(((\/(?:[^?#](?![^?#\/]*\.[^?#\/.]+(?:[?#]|$)))*\/?)?([^?#\/]*))(?:\?([^#]*))?(?:#(.*))?)/
    }
  };

  MobileRemote.addUriQuery = function(url, params) {
    var count, key, val, _i, _len;
    if (params !== null) {
      count = 0;
      if (url.indexOf("?") !== -1) {
        count = 1;
      }
      for (_i = 0, _len = params.length; _i < _len; _i++) {
        key = params[_i];
        val = params[key];
        if (val !== null) {
          if (count++ === 0) {
            url += "?";
          } else {
            url += "&";
          }
          url += key + "=" + encodeURIComponent(val);
        }
      }
    }
    return url;
  };

}).call(this);
