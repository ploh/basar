# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


get_seller_id = (list, text) ->
  if /^\d+$/.exec text
    number = parseInt(text)
    list[number]


SellersController = Paloma.controller "Sellers"
index_action = ->
  jQuery ->
    seller_list = $("#seller_list").data("list")
    $(document).keydown (event) ->
      if event.which == 'E'.charCodeAt(0) && !$(event.target).is "input"
        event.stopPropagation()
        event.preventDefault()
        text = prompt "Seller number:"
        if text?
          number = get_seller_id(seller_list, text)
          if number?
            window.location.href = "/sellers/" + number + "/edit"
          else
            alert("Seller number not found: " + text)
SellersController.prototype.index = index_action
SellersController.prototype.revenue = index_action

SellersController.prototype.edit = ->
  jQuery ->
    $(document).keydown (event) ->
      if event.keyCode == 27
        event.stopPropagation()
        event.preventDefault()
        window.location.href = "/sellers"
