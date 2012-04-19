(function() {

  MobileRemote.trim = function(base) {
    return base && (base.replace(/^[\s\xA0]+/, "").replace(/[\s\xA0]+$/, ""));
  };

  MobileRemote.startsWith = function(base, str) {
    return base && base.match("^" + str) !== null;
  };

  MobileRemote.endsWith = function(base, str) {
    return base && base.match(str + "$") !== null;
  };

  MobileRemote.escape = function(string) {
    if (string === null || typeof string === "undefined") {
      return "";
    } else {
      return string.toString().replace(/\"/g, '\\\"').replace(/\n/g, '\\\n');
    }
  };

  MobileRemote.escapeHTML = function(html) {
    if (html === null || typeof html === "undefined") {
      return "";
    }
    if (typeof html !== "string") {
      html = html.toString();
    }
    return html.replace(/&/g, "&amp;").replace(/\"/g, "&quot;").replace(/>/g, "&gt;").replace(/</g, "&lt;");
  };

  MobileRemote.joinAttributes = function(attributes) {
    var joined, key, value, _i, _len;
    if (attributes === null) {
      return null;
    }
    joined = "";
    for (_i = 0, _len = attributes.length; _i < _len; _i++) {
      key = attributes[_i];
      value = attributes[key];
      if (value !== null) {
        joined += " " + key + '="' + MobileRemote.escapeHTML(value) + '"';
      }
    }
    return joined;
  };

  MobileRemote.mergeHash = function(hash1, hash2) {
    var key, result, value;
    result = {};
    for (key in hash1) {
      value = hash1[key];
      result[key] = value;
    }
    for (key in hash2) {
      value = hash2[key];
      result[key] = value;
    }
    return result;
  };

  MobileRemote.cloneHash = function(hash) {
    var h, key, _i, _len;
    h = {};
    for (_i = 0, _len = hash.length; _i < _len; _i++) {
      key = hash[_i];
      h[key] = hash[key];
    }
    return h;
  };

  MobileRemote.splitNameAndExtension = function(path) {
    var extension, name;
    if (/[.]/.exec(path)) {
      extension = /[^.]+$/.exec(path)[0];
    } else {
      extension = null;
    }
    if (extension) {
      name = path.substring(0, path.length - extension.length - 1);
    } else {
      name = path;
    }
    return {
      name: name,
      extension: extension
    };
  };

}).call(this);
