(function() {
  var NoBody,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  NoBody = (function() {

    NoBody.name = 'NoBody';

    MobileRemote.Pages.NoBody = NoBody;

    function NoBody(remote) {
      this.remote = remote;
      this.render = __bind(this.render, this);

    }

    NoBody.prototype.render = function(request, response) {
      if (request.isScript) {
        return "// no body";
      } else {
        return this.remote.views(function(v) {
          return v.page('no_body', function() {
            v.toolbar();
            v.title("Invalid Page");
            return v.error("Internal Error: That page didn't contain anything.");
          });
        });
      }
    };

    return NoBody;

  })();

}).call(this);
