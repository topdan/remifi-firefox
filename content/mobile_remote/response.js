(function() {
  var Response;

  Response = (function() {

    Response.name = 'Response';

    MobileRemote.Response = Response;

    function Response() {
      this.code = 200;
      this.message = "OK";
      this.headers = {};
    }

    Response.prototype.headersString = function() {
      var key, webpage, _i, _len, _ref;
      webpage = "HTTP/1.1 " + this.code + " " + this.message + "\r\n";
      _ref = this.headers;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        key = _ref[_i];
        webpage += key + ("" + key + ": " + this.headers[key] + "\r\n");
      }
      webpage += "\r\n";
      return webpage;
    };

    return Response;

  })();

}).call(this);
