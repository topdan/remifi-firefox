# http://www.tek-tips.com/faqs.cfm?fid=6620

MobileRemote.trim = (base) ->
  base && (base.replace(/^[\s\xA0]+/, "").replace(/[\s\xA0]+$/, ""))

MobileRemote.startsWith = (base, str) ->
  base && base.match("^"+str) != null

MobileRemote.endsWith = (base, str) ->
  base && base.match(str+"$") != null

MobileRemote.escape =(string) ->
  if (string == null || typeof(string) == "undefined") 
    ""
  else
    string.toString().replace(/\"/g, '\\\"').replace(/\n/g, '\\\n')

MobileRemote.escapeHTML = (html) ->
  return "" if html == null || typeof(html) == "undefined"
  if (typeof(html) != "string")
    html = html.toString();
  
  html.replace(/&/g, "&amp;").replace(/\"/g, "&quot;").replace(/>/g, "&gt;").replace(/</g, "&lt;");

MobileRemote.joinAttributes = (attributes) ->
  return null if attributes == null
  
  joined = "";
  
  for key in attributes
    value = attributes[key];
    unless value == null
      joined += " " + key + '="' + MobileRemote.escapeHTML(value) + '"'
  
  joined

MobileRemote.mergeHash = (hash1, hash2) ->
  result = {};
  
  for key in hash1
    result[key] = hash1[key]
  
  for key in hash2
    result[key] = hash2[key]
  
  result

MobileRemote.cloneHash = (hash) ->
  h = {};
  for key in hash
    h[key] = hash[key];
  h

MobileRemote.splitNameAndExtension = (path) ->
  if /[.]/.exec(path)
    extension = /[^.]+$/.exec(path)[0]
  else
    extension = null
  
  if extension
    name = path.substring(0, path.length - extension.length - 1)
  else
    name = path
  
  { name: name, extension: extension }
