# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

# create_overlay = ->
#   d = document.createElement('div');
#   $(d).css(
#     background: 'lightgray',
# #     opacity: '0.4',
#     width: '50%',
#     height: '50%',
#     position: 'absolute',
#     top: '25%',
#     left: '25%',
#     zIndex: 100
#   ).attr('id', 'cash_overlay')
#   $('body').append(d)
#
# display_overlay = ->
#   if !$('#cash_overlay').length
#     create_overlay()
#   $('#cash_overlay').html \
#     """
#     <p>
#     #{$("#total_price").html()}
#     </p>
#     """
#   window.prompt "Cash given (in EUR):"
#   bind_overlay_hotkeys()

handle_errors = ->
  if $("#error_explanation").length
    $("audio").trigger "play"

set_focus = (focus_id) ->
  if $(".field_with_errors").length
    $(".field_with_errors input:first").focus()
  else
    if focus_id
      $("#" + focus_id).focus()
    else
      $(".field input").filter(-> $(this).val() == "").first().focus()

register_handler = ->
  $(".field input").blur ->
    if $(this).attr("size") == "7" && /^\s*$/.test $(this).val()
      $(this).val("a")
    $.ajax "/transactions/validate", { type: "POST", data: $("#transaction_form form").serialize(), timeout: 2000, success: replace_transaction_form }

replace_transaction_form = (data, status, jqXHR) ->
  focus_id = $(":focus").attr("id")
  focus_value = $(":focus").val()
#   if focus_id != "transaction_submit"
  $("#transaction_form").html data
  $("#" + focus_id).val focus_value
  process_page_change(focus_id)

process_page_change = (focus_id) ->
  bind_hotkeys()
  if $("#transaction_form").length
    $(".field input").focus(-> $(this).select())
    handle_errors()
    set_focus(focus_id)
    register_handler()
#   bind_overlay_hotkeys()

bind_hotkeys = ->
  $(document).keydown (event) ->
    target = switch event.keyCode
      when 'L'.charCodeAt(0) then "/transactions"
      when 'N'.charCodeAt(0) then "/transactions/new"
    if target
      event.stopPropagation()
      window.location.href = target
  $("#transaction_form input").keydown (event) ->
    if event.keyCode == 27
      event.preventDefault()
      event.stopPropagation()
      window.location.href = "/transactions"


# bind_overlay_hotkeys = ->
#   $(document).keyup (e) ->
#     if e.keyCode == 27
#       $("#cash_overlay").remove()
#   bind_element_to_hotkey "#cash_given_link", "g", display_overlay


TransactionsController = Paloma.controller "Transactions"
TransactionsController::default = ->
  jQuery ->
    process_page_change()
