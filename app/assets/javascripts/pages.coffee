# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

bind_hotkeys = ->
  $(document).keydown (event) ->
    target = switch event.which
      when 'A'.charCodeAt(0) then "/transactions/all"
      when 'L'.charCodeAt(0) then "/transactions"
      when 'N'.charCodeAt(0) then "/transactions/new"
      when 'S'.charCodeAt(0) then "/sellers"
    if target && !$(event.target).is "input"
      event.stopPropagation()
      window.location.href = target


jQuery ->
  bind_hotkeys()
