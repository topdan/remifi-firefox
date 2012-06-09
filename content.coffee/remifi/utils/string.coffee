# http://www.tek-tips.com/faqs.cfm?fid=6620

Remifi.trim = (base) ->
  base && (base.replace(/^[\s\xA0]+/, "").replace(/[\s\xA0]+$/, ""))

Remifi.startsWith = (base, str) ->
  base && base.match("^"+str) != null

Remifi.endsWith = (base, str) ->
  base && base.match(str+"$") != null

Remifi.externalURL = (url) ->
  return false unless url
  Remifi.startsWith(url, "http://") || Remifi.startsWith(url, "https://")

Remifi.escape =(string) ->
  if (string == null || typeof(string) == "undefined") 
    ""
  else
    string.toString().replace(/\"/g, '\\\"').replace(/\n/g, '\\\n')

Remifi.escapeHTML = (html) ->
  return "" if html == null || typeof(html) == "undefined"
  if (typeof(html) != "string")
    html = html.toString();
  
  html.replace(/&/g, "&amp;").replace(/\"/g, "&quot;").replace(/>/g, "&gt;").replace(/</g, "&lt;").replace(/&lt;br&gt;/g, '<br/>')

Remifi.joinAttributes = (attributes) ->
  return null if attributes == null
  
  joined = "";
  
  for key in attributes
    value = attributes[key];
    unless value == null
      joined += " " + key + '="' + Remifi.escapeHTML(value) + '"'
  
  joined

Remifi.mergeHash = (hash1, hash2) ->
  result = {};
  
  for key,value of hash1
    result[key] = value
  
  for key,value of hash2
    result[key] = value
  
  result

Remifi.cloneHash = (hash) ->
  h = {};
  for key in hash
    h[key] = hash[key];
  h

Remifi.splitNameAndExtension = (path) ->
  if /[.]/.exec(path)
    extension = /[^.]+$/.exec(path)[0]
  else
    extension = null
  
  if extension
    name = path.substring(0, path.length - extension.length - 1)
  else
    name = path
  
  { name: name, extension: extension }
