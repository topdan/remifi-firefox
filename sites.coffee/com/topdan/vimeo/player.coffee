class VimeoPlayer extends Player
  
  constructor: (@selector) ->
    super @selector
    
    @playAction = 'playPause'
    @fullscreenAction = 'toggleFullscreen'
    
    @setBox({width: 'full', valign: 'bottom', height: 42})
    @setPlay({x: 41, y: 20, delay: 500})
    @setFullscreenOn({align: 'right', x: 35, y: 18, delay: 500})
  
  controls: =>
    @playButton()
    @fullscreenToggle()
  
  playButton: () =>
    button('Play/Pause', @playAction)
  
  fullscreenToggle: =>
    toggle 'Fullscreen', @fullscreenAction, @isFullscreen
  
this.VimeoPlayer = VimeoPlayer