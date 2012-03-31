MobileRemote.Request = function() {
  var self = this
  
  this.remote_ip = null
  this.headers = {}
  
  this.setPath = function(path) {
    this.fullpath = path

    var smoothPath = this.cleanPath(path)
    
    var uri = new MobileRemote.URI("http://mobile-remote.topdan.com" + smoothPath)
    this.params = uri.queryKey
    this.path = uri.path
    
    if (this.params) {
      for (var key in this.params) {
        this.params[key] = decodeURIComponent(this.params[key])
      }
    }

  }
  
  
  this.cleanPath = function(path) {
    // app uses GET to pass in data, which uses '+' instead of '%20'
    return path.replace(/\+/g, '%20')
  }
  
}