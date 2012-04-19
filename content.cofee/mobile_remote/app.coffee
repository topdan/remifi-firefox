class App
  MobileRemote.App.Sandbox = App
  
  constructor: (@remote, @name) ->
    @remote = remote
    @name = name
    @code = null
    @filename = "/apps/#{name.replace(/\./g, '/')}.js"
    @url = null
    @uri = null
    @domains = null
    @imports = ['lib/json2']
    @metadata = {}
    @sandbox = null
    @crossDomains = []
    @api = new MobileRemote.Api(@);
    
    @code = @remote.env.fileContent(@filename)
    @extractMetadata(@code, @setMetadata)
  
  render: (uri, request, response) ->
    sandbox = @createSandbox();
    
    action = request.path.match(/\/([^\/]+)$/)
    action = action[1] if action
    
    limitedRequest = {
      protocol: uri.protocol,
      host: uri.host,
      port: uri.port,
      path: uri.path,
      directory: uri.directory,
      file: uri.file,
      anchor: uri.anchor,
      action: action, 
      params: request.params
    };
    
    json = Components.utils.evalInSandbox("render(#{JSON.stringify(limitedRequest)});", sandbox)
    
    if typeof json == "string"
      hash = JSON.parse(json)
      c = new MobileRemote.Views.Hash(@, request, response)
      c.perform(hash)
    else
      null
  
  createSandbox: ->
    sandbox = @api.createSandbox(null, {zepto: true})
    @evalInSandbox('app', "app = #{JSON.stringify({name: @name})}", sandbox)
    
    for importName in @imports
      file = "/apps/#{importName}.js"
      code = @remote.env.fileContent(file)
      @evalInSandbox(file, code, sandbox)
    
    # OPTIMIZE save this once there's a development reload mode going
    code = @remote.env.fileContent(@filename)
    @evalInSandbox(@filename, code, sandbox)
    sandbox
  
  evalInSandbox: (file, code, sandbox) =>
    try
      Components.utils.evalInSandbox(code, sandbox)
    catch err
      throw file + " " + err
  
  extractMetadata: (code, callback) =>
    regex = /\/\/ \@([^\ ]+)[\ ]+([^\n]+)/g
    
    return null if code == null
    
    matches = code.match(regex)
    if matches
      for match in matches
        m = match.match(/\/\/ \@([^\ ]+)[\ ]+([^\n]+)/)
        callback(m[1], m[2])
  
  setMetadata: (key, value) =>
    switch(key)
      when 'url'
        @url = value
        @uri = new MobileRemote.URI(@url);
        @domains = [@uri.host];
      
      when 'import'
        @imports.push(value)
      
      when 'domain'
        @domains ||= []
        @domains.push(value);
        
      when 'crossdomain'
        @crossDomains.push(value);
        
      else
        @metadata[key] = value
    
    value
    