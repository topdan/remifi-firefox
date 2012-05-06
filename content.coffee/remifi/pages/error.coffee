class Error
  Remifi.Pages.Error = Error
  
  constructor: (@remote) ->
  
  render: (err, request, response) =>
    @remote.views (v) ->
      if request.isScript
        response.headers["Content-Type"] = 'text/javascript'
        v.safeOut('remifi.error("' + v.escape(v.escapeHTML(err)) + '")');
      else
        v.page 'internal_error', ->
          v.toolbar();
          v.title("Error");
          
          v.out.push('<p class="error-message">I had trouble understanding this page. <a href="#" class="show-internal-error">Show details</a></p>');
          v.out.push('<p class="error-message internal-error-details" style="display:none">' + err + '</p>');
          
          v.br();
          v.br();
          v.button('Use Mouse App', '/mouse/index.html', {type: 'primary'})
