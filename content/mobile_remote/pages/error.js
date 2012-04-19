(function() {
  var Error,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  Error = (function() {

    Error.name = 'Error';

    MobileRemote.Pages.Error = Error;

    function Error(remote) {
      this.remote = remote;
      this.render = __bind(this.render, this);

    }

    Error.prototype.render = function(err, request, response) {
      return this.remote.views(function(v) {
        if (request.isScript) {
          return v.safeOut('mobileRemote.error("' + v.escape(v.escapeHTML(err)) + '")');
        } else {
          return v.page('internal_error', function() {
            v.toolbar();
            v.title("Error");
            v.out.push('<p class="error-message">I had trouble understanding this page. <a href="#" class="show-internal-error">Show details</a></p>');
            v.out.push('<p class="error-message internal-error-details" style="display:none">' + err + '</p>');
            v.br();
            v.br();
            return v.button('Use Mouse App', '/mouse/index.html', {
              type: 'primary'
            });
          });
        }
      });
    };

    return Error;

  })();

}).call(this);
