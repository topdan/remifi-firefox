`
// Firefox API functions need to be declared via function NAME, not name = function()
// which I'm not sure how to do via coffeescript
// so this is a bit of a hack-indirection

Remifi.Api = function(app) {
  
  this.createSandbox = function(url, options) {
    sandbox = app.remote.createSandbox(url, options)
    sandbox.importFunction(crossDomainGet)
    return sandbox;
  }
  
  function crossDomainGet(url) {
    // SECURITY TODO: get the domain's crossdomain.xml and see if it allows from this domain
    // TODO: timeout protection
  
    if (typeof url != "string")
      return null;
  
    var uri = new Remifi.URI(url);
    if (app.crossDomains.indexOf(uri.host) == -1)
      return null;
  
    var request = new XMLHttpRequest();
    request.open('GET', url, false);
    request.send(null);
  
    if (request.status === 200) {
      return request.responseText;
    } else {
      return null;
    }
  }
}
`