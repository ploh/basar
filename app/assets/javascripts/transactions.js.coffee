# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

handle_errors = ->
  if $("#error_explanation").length > 0
    $("audio").trigger "play"

replace_transaction_form = ->

jQuery ->
  handle_errors()
  if $("#transaction_form").length > 0
    $("#transaction_form input").blur ->
      $.ajax validate_transaction_path, { type: "GET", timeout: 3000, success: replace_transaction_form }
