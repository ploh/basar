# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


window.get_seller_id = (text) ->
  if /^\d+$/.exec text
    number = parseInt(text)
    window.seller_list[number] && window.seller_list[number][0]


jQuery ->
  window.seller_list = $("#seller_list").data("list")
