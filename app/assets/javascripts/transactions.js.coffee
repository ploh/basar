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

mark_error = (element) ->
  play_error_sound()
  element.parent().addClass "field_with_errors"
  setTimeout ( ->
    $(document.activeElement).off "blur" ),
    0
  setTimeout ( ->
    change_to_element = $(document.activeElement)
    setTimeout (-> change_to_element.blur input_blur_handler), 0
    element.focus() ),
    0

unmark_error = (element) ->
  element.parent().removeClass "field_with_errors"

is_valid_price = (element) ->
  /^\d*[.,]?\d*$/.test element.val()

seller_list =
  1: "AL"
  11: "NL"

validate_seller = (element) ->
  text = element.val()
  if /^\d+$/.test text
    number = parseInt text
    seller_list[number]? && element.val seller_list[number] + number

check_field = (element, test_function) ->
  if test_function element
    unmark_error element
  else
    mark_error element

play_error_sound = ->
  $("audio").trigger "play"

set_focus = (focus_id) ->
  if $(".field_with_errors").length
    $(".field_with_errors input:first").focus()
  else
    if focus_id
      $("#" + focus_id).focus()
    else
      $(".field input").filter(-> $(this).val() == "").first().focus()

input_blur_handler = ->
  field_name = /\[([^\]]*)\]$/.exec( $(this).attr('name') )[1]
  switch field_name
    when "price"
      check_field $(this), is_valid_price
    when "seller_code"
      check_field $(this), validate_seller
    else
      $.ajax "/transactions/validate", { type: "POST", data: $("#transaction_form form").serialize(), timeout: 2000, success: replace_transaction_form }

register_handler = ->
  $(".field input").blur input_blur_handler

replace_transaction_form = (data, status, jqXHR) ->
  focus_id = $(document.activeElement).attr("id")
  focus_value = $(document.activeElement).val()
#   if focus_id != "transaction_submit"
  $("#transaction_form").html data
  $("#" + focus_id).val focus_value
  process_page_change(focus_id)

process_page_change = (focus_id) ->
  bind_hotkeys()
  if $("#transaction_form").length
    $(".field input").focus(-> $(this).select())
    set_focus(focus_id)
    register_handler()
#   bind_overlay_hotkeys()

bind_hotkeys = ->
  $(document).keydown (event) ->
    target = switch event.which
      when 'L'.charCodeAt(0) then "/transactions"
      when 'N'.charCodeAt(0) then "/transactions/new"
    if target && !$(event.target).is "input"
      event.stopPropagation()
      window.location.href = target
  $("#transaction_form input").keydown (event) ->
    if event.keyCode == 27
      event.stopPropagation()
      event.preventDefault()
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
