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
  element.select()

unmark_error = (element) ->
  element.parent().removeClass "field_with_errors"

play_error_sound = ->
  $("audio").trigger "play"

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
  if field.val() == ""
    row_index = /\[(\d+)\]\[[^\]]*\]$/.exec( field.attr('name') )[1]
    if row_index > 0
      prev_row_index = parseInt(row_index) - 1
      prev_field = $("#" + field.attr("id").replace(row_index, prev_row_index))
      field.val prev_field.val()


TransactionsController = Paloma.controller "Transactions"
TransactionsController.prototype.new = ->
  jQuery ->
    $(document).keydown (event) ->
      target = $(event.target)
      if target.is "input"
        switch event.which
          when 38  # up arrow key
            event.stopPropagation()
            set_last_value target
          when 9, 13  # tab key, enter key
            match = /\[([^\]]*)\]$/.exec( target.attr('name') )
            if match
              field_name = match[1]
              correct = switch field_name
                when "price"
                  if /^\d*[.,]?\d*$/.test target.val().trim()
                    target.val target.val().replace(",", ".")
                    if target.val() < 30
                      true
                    else
                      play_error_sound()
                      confirm("Really?") || "abort"
                  else
                    false
                when "seller_code"
                  match = /^([a-zA-Z]*)\s*(\d+)$/.exec target.val().trim()
                  if match
                    initials = match[1].toUpperCase()
                    number = parseInt match[2]
                    if window.seller_list[number]? && ( !initials || initials == window.seller_list[number][1] )
                      target.val(window.seller_list[number][1] + number)
                      true
                    else
                      false
                  else
                    !target.val().trim()

              if typeof correct != 'undefined'
                if correct
                  if correct == "abort"
                    event.preventDefault()
                  unmark_error target
                else
                  if event.which != 13
                    event.preventDefault()
                  mark_error target

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
