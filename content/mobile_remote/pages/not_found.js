(function() {
  var NotFound,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  NotFound = (function() {

    NotFound.name = 'NotFound';

    MobileRemote.Pages.NotFound = NotFound;

    function NotFound(remote) {
      this.remote = remote;
      this.render = __bind(this.render, this);

    }

    NotFound.prototype.render = function(request, response) {
      return this.remote.views(function(v) {
        return v.page('not_found', function() {
          v.toolbar();
          v.title("Page Not Found");
          return v.error("Sorry, that page was not found.");
        });
      });
    };

    return NotFound;

  })();

}).call(this);
