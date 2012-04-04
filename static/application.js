function setupPages() {
  
  $('#mouse .touchpad').click(function(e) {
    var x = e.clientX;
    var y = e.clientY;
    
    var offset = $(this).offset();
    
    var dx = (x - offset.left)/offset.width;
    var dy = (y - offset.top)/offset.height;
    
    $.ajax({
      url: '/mouse/move.js?x=' + encodeURIComponent(dx) + '&y=' + encodeURIComponent(dy),
      success: function(script) {
        eval(script);
      }
    })
    
    e.preventDefault();
    return false;
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

MobileRemote = function(jQT) {
  
  this.error = function(message) {
    $('#error-message').html(message);
    jQT.goTo('#ajax_error');
  }
  
  this.show = function(url) {
    $.ajax({
      url: url,
      success: function(data) {
        jQT.insertPages(data, 'fade');
      }
    })
  }
  
  this.wait = function(url) {
    $.ajax({
      url: '/controls/wait.js?url=' + encodeURIComponent(url),
      success: function(script, status, request) {
        eval(script);
      }
    })
  }
  
}

$(function() {
  var jQT = new $.jQTouch({
      icon: '/static/jqtouch/images/jqtouch.png',
      addGlossToIcon: false,
      startupScreen: '/static/jqtouch/images/jqt_startup.png',
      statusBar: 'black',
      useAnimations: false
  });
  
  $(document).on('ajaxError', function(error, request) {
    mobileRemote.error('We could not connect to your computer. Try restarting the server.')
  });
  
  mobileRemote = new MobileRemote(jQT);
  
  setupPages();
})
