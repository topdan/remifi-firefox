this.keyboardPress = (key) ->
  currentPage().push({type: 'keyboard', action: 'press', key: key})

class this.Keyboard
  
  press: (key) =>
    keyboardPress(key)
