var jQT = new $.jQTouch({
    icon: '/static/jqtouch/images/jqtouch.png',
    addGlossToIcon: false,
    startupScreen: '/static/jqtouch/images/jqt_startup.png',
    statusBar: 'black',
    useAnimations: false
});

function setupPages() {
  $('#jqt').each(function() {
    var e = $(this);
    
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

$(function() {
  setupPages();
})
