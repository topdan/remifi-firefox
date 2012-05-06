function setupPages() {
  
  $('form').submit(function() {
    $(':focus').blur();
  })
  
  $('textarea.bookmarklet').click(function() {
    this.focus();
    this.select();
  })
  
  $('p a.show-internal-error').click(function() {
    $(this).parent('p').next().toggle();
    return false;
  })
  
  var isMoving = false;
  var waitingX = null;
  var waitingY = null;
  
  var mousePadTouched = function(element, event) {
    var x = event.clientX;
    var y = event.clientY;
    
    var offset = $(element).offset();
    
    var dx = (x - offset.left)/offset.width;
    var dy = (y - offset.top)/offset.height;
    
    moveMouse(dx, dy);
  }
  
  var moveMouse = function(x, y) {
    if (isMoving) {
      waitingX = x;
      waitingY = y;
    } else {
      isMoving = true;
      $.ajax({
        url: '/mouse/over.js?x=' + encodeURIComponent(x) + '&y=' + encodeURIComponent(y),
        success: function(script) {
          eval(script);
          isMoving = false;
          
          if (waitingX && waitingY) {
            moveMouse(waitingX, waitingY);
            waitingX = null;
            waitingY = null;
          }
        }
      })
    }
  }
  
  if ($.support.touch) {
    $('#mouse .touchpad').bind('touchstart', function(e) {
      var self = this;
      var target = $(e.target);
      
      target.on('touchmove', function(){
        mousePadTouched(self, e.touches[0])
      });
      
      target.on('touchend', function() {
        target.unbind('touchmove');
      })
      
      mousePadTouched(this, e.touches[0]);
      e.preventDefault();
      return false;
    });
    
  } else {
    $('#mouse .touchpad').click(function(e) {
      mousePadTouched(this, e);
      e.preventDefault();
      return false;
    });
    
  }
  
  $('a').click(function(e) {
    var message = $(this).attr('data-disabled-message');
    if (message) {
      alert(message);
      return false;
    }
    
    var remoteUrl = $(this).attr('data-remote-url');
    if (remoteUrl) {
      remifi.visit(remoteUrl);
      return false;
    }
  });
  
  $('#waiting .stopLoading').click(function(e) {
    remifi.stop();
    remifi.show('/controls/stop.html?url=%2F');
    e.preventDefault();
    return false;
  });
  
  $('#waiting .stopWaiting').click(function(e) {
    remifi.stop();
    remifi.show('/');
    e.preventDefault();
    return false;
  })
  
  $('input.standalone-toggle').click(function(e) {
    var checked = $(this).is(':checked')
    $(this).parents('form').submit()
  })
  
  $('#jqt').each(function() {
    var e = $(this);
    
    e.find('ul.list ul.actions a').swipe(function(evt, data) {
      var link = $(this);
      var li = link.parent().parent().parent();
      
      li.find('ul.actions').hide();
      li.find('a.title').show();
    });
    
    e.find('ul.list a').swipe(function(evt, data) {
      var link = $(this);
      var actions = link.next('ul.actions');
      if (actions.length > 0) {
        link.hide();
        actions.show();
      }
    });
  })
  
}

Remifi = function(jQT) {
  var self = this;
  
  this.error = function(message) {
    $('#error .error-message').html(message);
    jQT.goTo('#error');
  }
  
  this.show = function(url) {
    $.ajax({
      url: url,
      success: function(data) {
        jQT.insertPages(data, 'fade');
      }
    })
  }
  
  this.stop = function() {
    this.forceStop = true;
  }
  
  this.waitUnlessStopped = function(url) {
    if (!this.forceStop) {
      this.wait(url);
    }
  }
  
  this.wait = function(url, options) {
    if (options == null) options = {}
    this.forceStop = false;
    
    var ajaxOptions = {
      url: '/controls/wait.js?url=' + encodeURIComponent(url),
      success: function(script, status, request) {
        if (!self.forceStop)
          eval(script);
      }
    }
    
    if (options.ms) {
      setTimeout(function() { $.ajax(ajaxOptions) }, options.ms);
    } else {
      $.ajax(ajaxOptions)
    }
  }
  
  this.visit = function(url) {
    $.ajax({
      url: '/controls/visit.html?url=' + encodeURIComponent(url),
      success: function(data) {
        jQT.insertPages(data, 'fade');
      }
    })
  }
  
}

$(function() {
  jQT = new $.jQTouch({
      icon: '/static/images/icon.png',
      addGlossToIcon: false,
      startupScreen: '/static/images/splash.png',
      statusBar: 'black',
      useAnimations: false
  });
  
  $(document).on('ajaxError', function(error, request) {
    remifi.error('We could not connect to your computer. Try restarting the server.')
  });
  
  remifi = new Remifi(jQT);
  
  setupPages();
})
