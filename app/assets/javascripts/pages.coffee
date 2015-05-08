# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

jQuery ->
  $(document).keydown (event) ->
    action = null
    event_target = $(event.target)
    if event_target.is "input"
      if event.which == 27  # Escape key
        action = ->
          event_target.blur()
    else
      action = switch event.which
        when 'A'.charCodeAt(0) then "/transactions/all"
        when 'L'.charCodeAt(0) then "/transactions"
        when 'N'.charCodeAt(0) then "/transactions/new"
        when 'R'.charCodeAt(0) then "/sellers/revenue"
        when 'S'.charCodeAt(0) then "/sellers"
        when 'E'.charCodeAt(0) then ->
          text = prompt "Seller number:"
          if text?
            number = window.get_seller_id(text)
            if number?
              window.location.href = "/sellers/" + number + "/edit"
            else
              alert("Seller number not found: " + text)

    if action
      event.stopPropagation()
      if typeof action == 'string'
        window.location.href = action
      else
        action()
