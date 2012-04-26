class YouTubePlayer extends Player
  
  constructor: (@selector) ->
    super @selector
    
    @playAction = 'playPause'
    @startOverAction = 'startOver'
    @fullscreenAction = 'toggleFullscreen'
    
    if @isFullscreen
      @setBox({width: 'full', valign: 'bottom', height: 40})
      @setSeek({x1: 5, x2: @box.width, y: 0, delay: 500})
      @setPlay({valign: 'bottom', x: 35, y: 2, delay: 500})
    else
      @setBox({width: 'full', valign: 'bottom', height: 35})
      @setSeek({x1: 5, x2: @box.width, y: 3, delay: 250})
      @setPlay({x: 29, y: 25})

    @setFullscreenOff({key: 'escape'})
    @setFullscreenOn({align: 'right', x: 17, y: 23})
  
  controls: =>
    @playButton()
    @startOverButton()
    @fullscreenToggle()
  
  playButton: () =>
    button('Play/Pause', @playAction)
  
  startOverButton: =>
    if @isFullscreen
      button 'Start Over', @startOverAction, disabled: 'Exit fullscreen first'
    else
      button 'Start Over', @startOverAction
  
  fullscreenToggle: =>
    toggle 'Fullscreen', @fullscreenAction, @isFullscreen
  
this.YouTubePlayer = YouTubePlayer