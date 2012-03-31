// http://www.tek-tips.com/faqs.cfm?fid=6620

MobileRemote.trim = function(base){
  return (base.replace(/^[\s\xA0]+/, "").replace(/[\s\xA0]+$/, ""))
}

MobileRemote.startsWith = function(base, str) {
  return (base.match("^"+str)==str)
}

MobileRemote.endsWith = function(base, str) {
  return (base.match(str+"$")==str)
}

MobileRemote.escapeHTML = function(html) {
  if (typeof(html) != "string")
    html = html.toString()
  
  return html.replace(/&/g, "&amp;").replace(/\"/g, "&quot;").replace(/>/g, "&gt;").replace(/</g, "&lt;")
}

MobileRemote.joinAttributes = function(attributes) {
  if (attributes == null) return null
  
  var joined = ""
  
  for (var key in attributes) {
    var value = attributes[key]
    if (value != null)
      joined += " " + key + '="' + MobileRemote.escapeHTML(value) + '"'
  }
  
  return joined
}

MobileRemote.mergeHash = function(hash1, hash2) {
  var result = {}
  
  for (var key in hash1) {
    result[key] = hash1[key]
  }
  
  for (var key in hash2) {
    result[key] = hash2[key]
  }
  
  return result;
}

MobileRemote.cloneHash = function(hash) {
  var h = {}
  for (var key in hash) {
    h[key] = hash[key]
  }
  return h
}

MobileRemote.splitNameAndExtension = function(path) {
  var extension = (/[.]/.exec(path)) ? /[^.]+$/.exec(path)[0] : null;
  var name = extension ? path.substring(0, path.length - extension.length - 1) : path
  
  return {
    name: name,
    extension: extension
  }
}
