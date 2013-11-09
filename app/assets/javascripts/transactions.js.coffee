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
#   if $('#cash_overlay').length == 0
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
  if $("#error_explanation").length > 0
    $("audio").trigger "play"

set_focus = (focus_id) ->
  $("input").focus(-> $(this).select())
  if $(".field_with_errors").length > 0
    $(".field_with_errors input:first").focus()
  else
    if focus_id
      $("#" + focus_id).focus()
    else
      $(".field input").filter(-> $(this).val() == "").first().focus()

register_handlers = ->
  $("input.seller_code").blur ->
#     if $(this).attr("type") == "number" && /^\s*$/.test $(this).val()
#       $(this).val("a")
    $.ajax "/seller/validate_code", { type: "POST", data: $(this).val(), timeout: 2000, success: update_field($(this).attr("id")) }

replace_transaction_form = (data, status, jqXHR) ->
  focus_id = $(":focus").attr("id")
#   if focus_id != "transaction_submit"
  $("#transaction_form").html data
  process_page_change(focus_id)

process_page_change = (focus_id) ->
  bind_hotkeys()
  if $("#transaction_form").length > 0
    bind_transaction_form_hotkeys()
    handle_errors()
    set_focus(focus_id)
    register_handlers()
#   bind_overlay_hotkeys()

bind_element_to_hotkey = (selector, key, handler) ->
  element = $(selector)
  if element.length > 0
    if !handler
      handler = -> element[0].click()
    $(document).on('keypress', null, key, handler)

bind_link_to_hotkey = (href, key) ->
  bind_element_to_hotkey 'a[href="' + href + '"]', key

bind_hotkeys = ->
  bind_link_to_hotkey "/transactions", "l"
  bind_link_to_hotkey "/transactions/new", "n"
#   bind_element_to_hotkey "#cash_given_link", "g", display_overlay

bind_transaction_form_hotkeys = ->
  $("input").keyup (e) ->
    if e.keyCode == 27
      window.location.href = "/transactions"

# bind_overlay_hotkeys = ->
#   $(document).keyup (e) ->
#     if e.keyCode == 27
#       $("#cash_overlay").remove()
#   bind_element_to_hotkey "#cash_given_link", "g", display_overlay

jQuery ->
  process_page_change()
