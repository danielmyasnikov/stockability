# custom admin javascript manifest file
# add application speficic logic in the tree, add references to the file here

#= require products
#= require stock_levels
#= require tour_entries

$ ->
  $('.navbar-minimalize').click ->
    collapsed = Cookies.get('sa.collapsed')
    host      = $('#settings').data('host')

    if collapsed?
      Cookies.remove('sa.collapsed')
      $('#side-menu [data-toggle="tooltip"]').tooltip('destroy')
    else
      $('.mini-navbar [data-toggle="tooltip"]').tooltip()
      Cookies.set('sa.collapsed', true, { domain: '', expires: 7 })

  dateTimePicker = $('input[data-user-datetimepicker=true]').datetimepicker
    format:     'yyyy-mm-dd hh:ii:ss'
    minView:    0
    autoclose:  true

  $('.select2-users').select2
    theme: 'bootstrap'

  $('.mini-navbar [data-toggle="tooltip"]').tooltip()
