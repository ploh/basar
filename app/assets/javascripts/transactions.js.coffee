# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

handle_errors = ->
  if $("#error_explanation").length > 0
    $("audio").trigger "play"

set_focus = ->
  if $(".field_with_errors").length > 0
    $(".field_with_errors input:first").select()
    $(".field_with_errors input:first").focus()
  else
    $(".field input").filter(-> $(this).val() == "").first().focus()

register_handler = ->
  if $("#transaction_form").length > 0
    $(".field input").blur ->
      $.ajax "/transactions/validate", { data: $("#transaction_form form").serialize(), timeout: 2000, success: replace_transaction_form }

replace_transaction_form = (data, status, jqXHR) ->
  $("#transaction_form").html data
  process_page_change()

process_page_change = ->
  handle_errors()
  set_focus()
  register_handler()

jQuery ->
  process_page_change()
