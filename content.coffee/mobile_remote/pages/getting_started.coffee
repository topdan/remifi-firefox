class GettingStarted
  MobileRemote.Pages.GettingStarted = GettingStarted
  
  constructor: (@remote) ->
  
  render: (request, response) =>
    @index(request, response);
  
  index: (request, response) =>
    @remote.views (v) =>
      v.page 'getting-started', =>
        
        dns = Components.classes["@mozilla.org/network/dns-service;1"].getService(Components.interfaces.nsIDNSService)
        hostname = dns.myHostName
        
        v.template '/views/getting-started/index.html', {
          port: @remote.port,
          hostname: hostname
        }