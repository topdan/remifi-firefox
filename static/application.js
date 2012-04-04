function setupPages() {
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
    jQT.goTo('#ajax_error');
  });
  
  mobileRemote = new MobileRemote(jQT);
  
  setupPages();
})
