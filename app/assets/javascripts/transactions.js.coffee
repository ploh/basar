# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

handle_errors = ->
  if $("#error_explanation").length > 0
    $("audio").trigger "play"

set_focus = (focus_id) ->
  $(".field input").focus(-> $(this).select())
  if $(".field_with_errors").length > 0
    $(".field_with_errors input:first").focus()
  else
    if focus_id
      $("#" + focus_id).focus()
    else
      $(".field input").filter(-> $(this).val() == "").first().focus()

register_handler = ->
  $(".field input").blur ->
    if $(this).attr("type") == "number" && /^\s*$/.test $(this).val()
      $(this).val("a")
    $.ajax "/transactions/validate", { data: $("#transaction_form form").serialize(), timeout: 2000, success: replace_transaction_form }

replace_transaction_form = (data, status, jqXHR) ->
  focus_id = $(":focus").attr("id")
#   if focus_id != "transaction_submit"
  $("#transaction_form").html data
  process_page_change(focus_id)

process_page_change = (focus_id) ->
  if $("#transaction_form").length > 0
    handle_errors()
    set_focus(focus_id)
    register_handler()

bind_link_to_hotkey = (href, key) ->
  link = $('a[href="' + href + '"]')
  if link.length > 0
    $(document).on('keypress', null, key, -> link[0].click())

jQuery ->
  bind_link_to_hotkey "/transactions", "l"
  bind_link_to_hotkey "/transactions/new", "n"
  process_page_change()
