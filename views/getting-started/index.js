$(function() {
  var findAddresses = function() {
    $.ajax({
      url: '/getting-started/addresses.json',
      dataType: 'json',
      success: function(data) {
        if (data.message == 'wait') {
          setTimeout(function() { findAddresses() }, 1000);
        } else {
          var spot = $('#addresses')
          spot.html('')
          for (var i=0 ; i < data.addresses.length ; i++) {
            spot.append('<li>' + data.addresses[i] + '</li>');
          }
        }
      }
    })
  }
  
  findAddresses()
})