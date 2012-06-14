$ ->
  user_controls = $ "#user_controls"
  controls_clicker = $ "p", user_controls
  controls_open = false

  original_top = user_controls.css "margin-top"

  hide = ->
    user_controls.stop().animate "margin-top": original_top
    controls_open = false

  peek = -> user_controls.stop().animate "margin-top": "-1.25em"

  show = ->
    user_controls.stop().animate "margin-top": "0em"
    controls_open = true

  controls_clicker.hover ->
      peek() if controls_open isnt true
    , ->
      hide() if controls_open isnt true

  controls_clicker.click ->
    if controls_open then hide() else show()



