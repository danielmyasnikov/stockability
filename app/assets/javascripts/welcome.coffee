# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
#= require jquery
#= require jquery_ujs
#= require jquery-ui

$(document).ready ->
  $('#register-interest').submit (events) ->
    email = $('#register-interest .sa-input').val()
    event.preventDefault();
