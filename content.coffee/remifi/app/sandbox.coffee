class Sandbox
  Remifi.App.Sandbox = Sandbox
  
  constructor: (@remote, @name) ->
    @remote = remote
    @name = name
    @code = null
    @filename = "/sites/#{name.replace(/\./g, '/')}.js"
    @domains = null
    @imports = []
    @std_imports = ['lib/json2', 'lib/render', 'lib/routes', 'lib/url', 'lib/view', 'lib/zepto-ext']
    @view_imports = ['lib/view/form', 'lib/view/http', 'lib/view/keyboard', 'lib/view/mouse', 'lib/view/page', 'lib/view/player']
    @metadata = {}
    @sandboxes = {}
    @crossDomains = []
    @api = new Remifi.Api(@)
    
    @code = @remote.env.fileContent(@filename)
    @extractMetadata(@code, @setMetadata)
  
  render: (uri, request, response) ->
    sandbox = @sandboxes[uri.host] if uri.host
    if typeof sandbox == 'undefined'
      sandbox = @createSandbox()
      # FIXME saved sandboxes need an updated document/window/etc
      # @sandboxes[uri.host] = sandbox unless @remote.env.isDevMode
    
    match = request.path.match(/\/([^\/\.]+)\.?(js)?$/)
    if match
      action = match[1]
      format = match[2] || "html"
    
    limitedRequest = {
      protocol: uri.protocol,
      url: uri.toString(),
      host: uri.host,
      port: uri.port,
      path: uri.path,
      query: uri.query,
      queries: uri.queryKey,
      directory: uri.directory,
      file: uri.file,
      anchor: uri.anchor,
      action: action,
      format: format,
      params: request.params
    };
    
    json = Components.utils.evalInSandbox("render(#{JSON.stringify(limitedRequest)});", sandbox)
    
    if format == "js"
      response.headers["Content-Type"] = 'text/javascript'
      return "// #{@name}##{action}"
    
    if typeof json == "string"
      hash = JSON.parse(json)
      c = new Remifi.Views.Hash(@, request, response)
      c.perform(hash)
    else
      null
  
  createSandbox: ->
    sandbox = @api.createSandbox(null, {zepto: true})
    @evalInSandbox('app', "app = #{JSON.stringify({name: @name})}", sandbox)
    
    @importFiles(sandbox, @imports)
    
    # OPTIMIZE save this once there's a development reload mode going
    code = @remote.env.fileContent(@filename)
    @evalInSandbox(@filename, code, sandbox)
    sandbox
  
  importFiles: (sandbox, names) =>
    for name in names
      @importFile(sandbox, name)
  
  importFile: (sandbox, name) =>
    if name == "lib/std"
      @importFiles sandbox, @std_imports
    else if name == 'lib/view'
      @importFiles sandbox, @view_imports
    else
      file = "/sites/#{name}.js"
      code = @remote.env.fileContent(file)
      @evalInSandbox(file, code, sandbox)
  
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
      when 'import'
        @imports.push(value.replace(/\./g, '/'))
      
      when 'domain'
        @domains ||= []
        @domains.push(value);
        
      when 'crossdomain'
        @crossDomains.push(value);
        
      else
        @metadata[key] = value
    
    value
