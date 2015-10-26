$(document).ready ->
  $('#register-interest').submit (events) ->
    email = $('#register-interest .sa-input').val()
    event.preventDefault();
