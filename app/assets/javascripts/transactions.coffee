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

mark_error = (event, element) ->
  play_error_sound()
  element.parent().addClass "field_with_errors"
  event.preventDefault()
  element.select()

unmark_error = (element) ->
  element.parent().removeClass "field_with_errors"

is_valid_price = (text) ->
  /^\d*[.,]?\d*$/.test text.trim()

is_high_price = (price) ->
  price >= 30

is_valid_seller = (text, new_text) ->
  match = /^([a-zA-Z]*)\s*(\d+)$/.exec text
  if match
    initials = match[1].toUpperCase()
    number = parseInt match[2]
    if window.seller_list[number]? && ( !initials || initials == window.seller_list[number][1] )
      new_text.val = window.seller_list[number][1] + number
  else
    !text.trim()

check_and_correct_field = (event, element, test_function, warn_function) ->
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
    mark_error event, element

play_error_sound = ->
  $("audio").trigger "play"
1

expand_table = ->
  rows = $("#items_table > tbody > tr")
  last_row = rows.filter(":last")
  new_row = last_row.clone()

  last_index = parseInt(rows.length) - 1
  new_index = last_index + 1

  $(".field input", last_row).each ->
    $(this).off "focus", expand_table

  $(".field label", new_row).each ->
    $(this).attr "for", $(this).attr("for").replace(last_index, new_index)
  $(".field input", new_row).each ->
    $(this).attr "id", $(this).attr("id").replace(last_index, new_index)
    $(this).attr "name", $(this).attr("name").replace(last_index, new_index)
    $(this).focus ->
      $(this).select()
    $(this).focus expand_table

  new_row.insertAfter(last_row)


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
      target = $(event.target)
      if target.is "input"
        switch event.which
          when 38  # up arrow key
            event.stopPropagation()
            set_last_value(event.target)
          when 9, 13  # tab key, enter key
            match = /\[([^\]]*)\]$/.exec( target.attr('name') )
            if match
              field_name = match[1]
              switch field_name
                when "price"
                  check_and_correct_field event, target, is_valid_price, is_high_price
                when "seller_code"
                  check_and_correct_field event, target, is_valid_seller
    $(".field input").each ->
      $(this).focus ->
        $(this).select()
    $(".field input", $("#items_table > tbody > tr").filter(":last")).each ->
      $(this).focus expand_table
    if $(".field_with_errors").length
      $(".field_with_errors input:first").focus()
      play_error_sound()
    else
      $(".field input").filter(-> $(this).val() == "").first().focus()
    # bind_overlay_hotkeys()
