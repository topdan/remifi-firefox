# Simple JavaScript Templating
# John Resig - http://ejohn.org/ - MIT Licensed
# repurposed by Dan Cunning - http://www.topdan.com - MIT Licensed
Remifi.microtemplate = (code) ->
  new Function("obj",
      "var p=[],print=function(){p.push.apply(p,arguments);};" +
      
      # Introduce the data as local variables using with(){}
      "with(obj){p.push('" +
      
      # Convert the template into pure JavaScript
      code
        .replace(/[\r\t\n]/g, " ")
        .split("<%").join("\t")
        .replace(/((^|%>)[^\t]*)'/g, "$1\r")
        .replace(/\t=(.*?)%>/g, "',$1,'")
        .split("\t").join("');")
        .split("%>").join("p.push('")
        .split("\r").join("\\'") + "');}return p.join('');")