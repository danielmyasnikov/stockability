# custom admin javascript manifest file
# add application speficic logic in the tree, add references to the file here

#= require products
#= require stock_levels


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

  datatable = $('#datatable-simple').DataTable
    searching: false
    ordering: true
    processing: true

  $('.mini-navbar [data-toggle="tooltip"]').tooltip()
