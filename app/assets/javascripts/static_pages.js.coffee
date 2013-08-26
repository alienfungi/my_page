# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ->
  packmanResize = () ->
    packman = document.getElementById "packman"
    correct_ratio = 22 / 19
    width = $("#packman").width()
    if packman != null
      packman.style.height = (width * correct_ratio) + "px"

  # on resize
  $(window).resize -> packmanResize()
  # on init
  packmanResize()

  validate_field = (field, expression = //) ->
    parent = field.parent()
    parent.removeClass "has-error"
    parent.removeClass "has-warning"
    if field.val() == ""
      parent.addClass "has-error"
      false
    else if !expression.test(field.val())
      parent.addClass "has-warning"
      false
    else
      true

  window.validate_comment = () ->
    email_regex = /^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/
    valid = true
    unless validate_field($("#comment_name")) then valid = false
    unless validate_field($("#comment_email"), email_regex) then valid = false
    valid

  window.post_score = (arg) ->
    display = document.getElementById("score")
    if display != null
      display.innerHTML = "score: " + arg

  window.post_lives = (arg) ->
    display = document.getElementById("lives")
    if display != null
      display.innerHTML = "lives: " + arg

  $('#javaThumbs').on 'mouseenter', '.container', ()->
    $(this).stop(true, true).animate {'opacity': '1'}

  $('#javaThumbs').on 'mouseleave', '.container', ()->
    $(this).stop(true, true).animate {'opacity': '0.75'}
