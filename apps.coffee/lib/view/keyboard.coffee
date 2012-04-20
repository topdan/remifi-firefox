@keyboardPress = (key) ->
  currentPage().push({type: 'keyboard', action: 'press', key: key})

class Keyboard
  
  press: (key) =>
    keyboardPress(key)
