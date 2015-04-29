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
  # deactivate blur handler of newly focused element ->
  # setTimeout() because this code here is executed _before_ the focus actually changes
  setTimeout (-> $(document.activeElement).off "blur"), 0
  # re-focus the currently focused element (will be unfocused right after this blur handler finishes)
  # ...and afterwards reinstall the blur handler of the intermediately focused element
  setTimeout( ( ->
      newly_focused_element = $(document.activeElement)
      setTimeout (-> newly_focused_element.blur input_blur_handler), 0
      element.focus() ),
    1 )

unmark_error = (element) ->
  element.parent().removeClass "field_with_errors"

is_valid_price = (text) ->
  /^\d*[.,]?\d*$/.test text.trim()

is_high_price = (price) ->
  price >= 30

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

check_and_correct_field = (element, test_function, warn_function) ->
  # wrapper for pass-by-modifiable-reference
  new_val = val: element.val()
  correct = false
  if test_function element.val(), new_val
    correct = true
    if warn_function && warn_function new_val.val
      play_error_sound()
      correct = confirm "Really?"
  if correct
    element.val new_val.val
    unmark_error element
  else
    mark_error element

play_error_sound = ->
  $("audio").trigger "play"

input_blur_handler = ->
  field_name = /\[([^\]]*)\]$/.exec( $(this).attr('name') )[1]
  switch field_name
    when "price"
      check_and_correct_field $(this), is_valid_price, is_high_price
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
          register_field this
        new_row.insertAfter(last_row)
    when "seller_code"
      check_and_correct_field $(this), is_valid_seller

register_field = (field) ->
  $(field).blur input_blur_handler
  $(field).focus(-> $(this).select())

# bind_overlay_hotkeys = ->
#   $(document).keyup (e) ->
#     if e.keyCode == 27
#       $("#cash_overlay").remove()
#   bind_element_to_hotkey "#cash_given_link", "g", display_overlay

set_last_value = (field) ->
  if $(field).val() == ""
    row_index = /\[(\d+)\]\[[^\]]*\]$/.exec( $(field).attr('name') )[1]
    if row_index > 0
      prev_row_index = parseInt(row_index) - 1
      prev_field = $("#" + $(field).attr("id").replace(row_index, prev_row_index))
      $(field).val(prev_field.val())


TransactionsController = Paloma.controller "Transactions"
TransactionsController.prototype.new = ->
  jQuery ->
    $(document).keydown (event) ->
      if event.keyCode == 27
        event.stopPropagation()
        event.preventDefault()
        window.location.href = "/transactions"
      if $(event.target).is "input"
        if event.keyCode == 38
          event.stopPropagation()
          set_last_value(event.target)
#        if event.keyCode == 13
#          event.stopPropagation()
#          form_tag = $(event.target).closest("form")
#          setTimeout ( -> $(event.target).blur() ), 0
#          setTimeout ( -> form_tag.submit() ), 100
    seller_list = $("#seller_list").data("list")
    $(".field input").each ->
      register_field this
    if $(".field_with_errors").length
      $(".field_with_errors input:first").focus()
      play_error_sound()
    else
      $(".field input").filter(-> $(this).val() == "").first().focus()
    # bind_overlay_hotkeys()
