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

is_valid_price = (text) ->
  /^\d*[.,]?\d*$/.test text.trim()

seller_list =

is_valid_seller = (text, new_text) ->
  match = /^([a-zA-Z]*)\s*(\d+)$/.exec text
  if match
    initials = match[1].toUpperCase()
    number = parseInt match[2]
    if seller_list[number]? && ( !initials || initials == seller_list[number] )
      new_text.val = seller_list[number] + number
  else
    !text.trim()

check_and_correct_field = (element, test_function) ->
  new_val = val: element.val()
  if test_function element.val(), new_val
    element.val new_val.val
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
      check_and_correct_field $(this), is_valid_price
      # TODO also check corresponding seller
      row_index = /\[(\d+)\]\[[^\]]*\]$/.exec( $(this).attr('name') )[1]
      transaction_rows = $("table#items_table > tbody > tr")
      if row_index >= transaction_rows.length - 3
        last_row = transaction_rows.filter(":last")
        last_row_index = /\[(\d+)\]\[[^\]]*\]$/.exec( $(".field input", last_row).attr('name') )[1]
        new_row_index = parseInt(last_row_index) + 1
        console.log new_row_index
        new_row = last_row.clone()
        $(".field label", new_row).each ->
          $(this).attr("for", $(this).attr("for").replace(last_row_index, new_row_index))
        $(".field input", new_row).each ->
          $(this).attr("id", $(this).attr("id").replace(last_row_index, new_row_index))
          $(this).attr("name", $(this).attr("name").replace(last_row_index, new_row_index))
        new_row.insertAfter(last_row)
    when "seller_code"
      check_and_correct_field $(this), is_valid_seller

register_handler = ->
  $(".field input").blur input_blur_handler

update_seller_list = ->
  seller_list = $("#seller_list").data("list")

process_page_change = (focus_id) ->
  bind_hotkeys()
  if $("#transaction_form").length
    update_seller_list()
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
TransactionsController.prototype.index = ->
  jQuery ->
    process_page_change()
