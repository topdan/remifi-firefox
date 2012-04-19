class Keyboard
  MobileRemote.Pages.Keyboard = Keyboard
  
  constructor: (@remote) ->
    @delay = 200;
    @program = "/bin/keyboard";
    @x = null;
    @y = null;
  
  render: (request, response) =>
    if request.path == '/keyboard/index.html' || request.path == '/keyboard/'
      @index(request, response);
      
    else if request.path == '/keyboard/type.html'
      @typeText(request, response);
      
    else if request.path == '/keyboard/escape.js'
      @pressEscape(request, response);
      
    else if request.path == '/keyboard/return.js'
      @pressReturn(request, response);
  
  index: (request, response) =>
    currentText = @currentText
    
    @remote.views (v) ->
      v.page 'keyboard-page', ->
        v.toolbar();

        v.template('/views/keyboard.html', {current: currentText()});

        v.systemApps([
          {title: 'mouse', url: '/mouse/', icon: {url: '/static/images/mouse.png'}},
          null,
          null, # {title: 'tab up', url: '/keyboard/tab-up.js'},
          null, # {title: 'tab down', url: '/keyboard/tab-down.js'},
        ]);

  typeText: (request, response) =>
    sandbox = @remote.createSandbox(null, {zepto: true});
    text = request.params["text"] || "";

    view = new MobileRemote.Views.Base(@remote.env);
    code = 'Zepto(":focus").val("' + view.escape(text) + '")';

    try
      Components.utils.evalInSandbox(code, sandbox);
    catch err
      # can't type text onto this page

    @index(request, response);

  pressEscape: (request, response) =>
    @press('escape');

  pressReturn: (request, response) =>
    @press('return');

  press: (key) =>
    if key == 'escape' || key == 'return'
      @remote.env.exec("/bin/keyboard", ['-key', key])

  currentText: () =>
    try
      sandbox = @remote.createSandbox(null, {zepto: true});
      code = 'Zepto(":focus").val()';
      current = Components.utils.evalInSandbox(code, sandbox);
      current if typeof current == "string"
    catch err
      null
  
  # this.tabUp = function(request, response) {
  #   var sandbox = remote.createSandbox(null, {zepto: true});
  #   try {
  #     var code = "var e = $(':focus').get(0) || $('form').get(0).elements[0]; var f = e.form ; for (var i=0 ; i < f.elements.length ; i++) { if (e == f.elements[i]) { $(f.elements[i+1]).focus(); } }";
  #     
  #     Components.utils.evalInSandbox(code, sandbox);
  #   } catch (err) {
  #     
  #   }
  # }
  # 
  # this.tabDown = function(request, response) {
  #   var sandbox = remote.createSandbox(null, {zepto: true});
  #   try {
  #     var code = "var e = $(':focus').get(0) || $('form').get(0).elements[0]; var f = e.form ; for (var i=0 ; i < f.elements.length ; i++) { if (e == f.elements[i]) { $(f.elements[i-1]).focus(); } }";
  #     
  #     Components.utils.evalInSandbox(code, sandbox);
  #   } catch (err) {
  #     
  #   }
  # }
