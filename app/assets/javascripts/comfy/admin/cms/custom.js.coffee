# custom admin javascript manifest file
# add application speficic logic in the tree, add references to the file here

#= require comfy/admin/cms/products
#= require comfy/admin/cms/stock_levels


$ ->
  $('.navbar-minimalize').click ->
    collapsed = Cookies.get('sa.collapsed')
    host      = $('#settings').data('host')

    if collapsed?
      Cookies.remove('sa.collapsed')
    else
      Cookies.set('sa.collapsed', true, { domain: '', expires: 7 })


  datatable = $('#datatable-simple').DataTable
    searching: false
    ordering: true
    processing: true
