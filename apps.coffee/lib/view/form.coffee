this.form = (action, callback) ->
  form = new Form()
  callback(form)
  currentPage().push({type: 'form', action: action, content: form.toArray()})

class Form
  
  constructor: ->
    @content = []
    @currentFieldset = null
  
  toArray: =>
    @content
  
  out: (hash) =>
    if @currentFieldset
      @currentFieldset.content.push(hash)
    else
      @content.push(hash)
  
  fieldset: (callback) ->
    @currentFieldset = {type: 'fieldset', content: []}
    callback()
    @content.push(@currentFieldset)
    @currentFieldset = null
  
  br: =>
    @out({type: 'br'})
  
  url: (name, options) =>
    @input('url', name, options)
  
  search: (name, options) =>
    @input('search', name, options)
  
  submit: (name, options) =>
    @input('submit', name, options)
  
  input: (type, name, options) =>
    options ||= {}
    @out({type: type, name: name, placeholder: options.placeholder, value: options.value})
