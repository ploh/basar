# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

jQuery ->
  
  handle_errors

handle_errors: ->
  if $("#error_explanation").length() > 0
    $('audio').trigger "play"
