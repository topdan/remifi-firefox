class Form
  Remifi.Views.Form = Form
  
  constructor: (@view, @env, @formUrl, @options) ->
    @options ||= {}
    
    @inFieldset = null;
    @out = ['<form action="' + @formUrl + '" method="GET">'];
  
  html: =>
    @out.push('</ul></form>')
    @out.join("");

  escape: (string) =>
    Remifi.escape(string)

  escapeHTML: (string) =>
    Remifi.escapeHTML(string)

  fieldset: (callback) =>
    @out.push('<ul class="edit">')
    @inFieldset = true;
    callback();
    @inFieldset = false;
    @out.push('</ul>')

  br: =>
    @out.push("<br/>")

  toggle: (title, isOn, options) =>
    rest = "";
    rest = rest + ' name="' + options.name + '"' if options.name
    rest = rest + ' class="standalone-toggle"' if options.standAlone
    rest = rest + ' checked="CHECKED"' if isOn
    
    input = '<input type="checkbox"' + rest + '/>';
    code = title + '<span class="toggle">' + input + '</span>'
    code = '<li>' + code + '</li>' if @inFieldset
    @out.push(code)

  url: (name, options) =>
    @input('url', name, options)

  search: (name, options) =>
    @input('search', name, options)

  submit: (name, url, options) =>
    options ||= {}
    
    klass = null;
    if options.type == "info"
      klass = "grayButton";

    else if options.type == "danger"
      klass = "redButton";

    else if options.type == "primary"
      klass = "greenButton";

    else
      klass = "whiteButton";

    @out.push('<a class="submit ' + @escape(klass) + '" href="' + @escape(url) + '" style="">' + @escapeHTML(name) + '</a>')

  input: (type, name, options) =>
    options ||= {}
    
    rest = "";
    if options.placeholder
      rest = rest + ' placeholder="' + @escape(options.placeholder) + '"';
    
    if options.value
      rest = rest + ' value="' + @escape(options.value) + '"';

    code = '<input type="' + @escape(type) + '" name="' + @escape(name) + '"' + rest + '/>';
    code = '<li>' + code + '</li>' if @inFieldset
    @out.push(code)

