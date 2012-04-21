this.mouseClick = (x, y, delay) ->
  currentPage().push({type: 'mouse', action: 'click', x: x, y: y, delay: delay})

this.mouseOver = (x, y, delay) ->
  currentPage().push({type: 'mouse', action: 'over', x: x, y: y, delay: delay})

this.clickOn = (elem, options) ->
  options ||= {}
  options.control ||= false
  options.alt ||= false
  options.shift ||= false
  options.meta ||= false
  options.button ||= 0

  elem = elem.get(0)

  evt = document.createEvent("MouseEvents")
  evt.initMouseEvent('click', true, true, null, 0, 0, 0, 0, 0, options.control, options.alt, options.shift, options.meta, options.button, null)

  elem.dispatchEvent(evt)

class this.Mouse
  
  click: (x, y, delay) ->
    x = Math.floor(x)
    y = Math.floor(y)
    
    mouseClick(x, y, delay)
  
  over: (x, y, delay) ->
    x = Math.floor(x)
    y = Math.floor(y)
    
    mouseOver(x, y, delay)
  
  line: (val, x1, x2) =>
    @linearlyInterpolate(0, x1, 21, x2, val)
  
  linearlyInterpolate: (x1, y1, x2, y2, t) ->
    m = (y2 - y1) / (x2 - x1);
    b = y1 - m * x1
    m * t + b;
