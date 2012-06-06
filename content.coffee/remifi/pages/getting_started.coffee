class GettingStarted
  Remifi.Pages.GettingStarted = GettingStarted
  
  constructor: (@remote) ->
  
  render: (request, response) =>
    if request.path == '/getting-started/index.js'
      @script request, response
    else if request.path == '/getting-started/addresses.json'
      @pingAddresses request, response
    else
      @index(request, response)
  
  index: (request, response) =>
    @addresses = null
    setTimeout =>
      @findAddresses()
    , 10
    
    @remote.views (v) =>
      v.page 'getting-started', =>
        
        dns = Components.classes["@mozilla.org/network/dns-service;1"].getService(Components.interfaces.nsIDNSService)
        hostname = dns.myHostName
        
        v.template '/views/getting-started/index.html', {
          port: @remote.port,
          addresses: @addresses,
          installPath: @remote.env.extensionPath
        }
  
  script: (request, response) =>
    response.noLayout = true
    @remote.views (v) =>
      v.rawTemplate '/views/getting-started/index.js'
  
  pingAddresses: (request, response) =>
    response.noLayout = true
    
    if @foundAddresses
      json = {addresses: @addresses}
    else
      json = {message: 'wait'}
    
    JSON.stringify json
  
  findAddresses: () =>
    @addresses = []
    
    dns = Components.classes["@mozilla.org/network/dns-service;1"].getService(Components.interfaces.nsIDNSService)
    hostname = dns.myHostName
    
    @addresses.push "http://#{hostname.toLowerCase()}.local:#{@remote.port}" unless @remote.env.isWindows
    
    try
      record = dns.resolve(hostname, 0)
      while record.hasMore()
        address = record.getNextAddrAsString()
        if address.match(/^((25[0-5]|2[0-4][0-9]|1[0-9]{2}|[0-9]{1,2})\.){3}(25[0-5]|2[0-4][0-9]|1[0-9]{2}|[0-9]{1,2})$/)
          @addresses.push "http://#{address}:#{@remote.port}"
    catch err
      Components.utils.reportError "Could not detect your IP: #{err}"
    
    @foundAddresses = true