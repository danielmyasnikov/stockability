#= require dataTables/jquery.dataTables
#= require dataTables/bootstrap/3/jquery.dataTables.bootstrap
#= require select2

Stockability = {}

Stockability.StockLevel = ($) ->

  check_stock_levels = (is_checked) ->
    assign_available(is_checked)
    for checkbox in $('#stock-levels .check')
      $(checkbox).prop('checked', is_checked)

  check_stock_level = (is_checked, checkbox) ->
    assign_available(is_checked)
    $(checkbox).prop('checked', is_checked)

  assign_available = (is_checked, is_selected) ->
    is_assign_available = false

    if is_selected?
      is_assign_available = verify_checked_value()

    if is_checked == true
      is_assign_available = verify_selected_value()

    if is_assign_available == true
      $('#assign-results').attr('disabled', false)
    else
      $('#assign-results').attr('disabled', true)

  verify_checked_value = ->
    $('#stock-levels .check').is(':checked') == true

  verify_selected_value = ->
    $('#tour_id').val() != ""

  $('#assign-results').attr('disabled', true)
  $('.filter-select').select2
    theme: 'bootstrap'
  datatable = $('#stock-levels').DataTable
    searching:  false
    ordering:   false
    processing: true

  $('#reset-all').click (e) ->
    e.preventDefault()
    $('#bin_code_filter').val([])
    $('#location_code_filter').val([])
    $('#sku_filter').val([])
    window.location.replace '/admin/stock_levels'

  $('#filter-results').click (e) ->
    e.preventDefault()
    sku_params =      $('#sku_filter').val()           || []
    bin_code_params = $('#bin_code_filter').val()      || []
    loc_code_params = $('#location_code_filter').val() || []

    sku_params      = sku_params?.join(',')
    bin_code_params = bin_code_params?.join(',')
    loc_code_params = loc_code_params?.join(',')
    filter_params   = "sku=#{sku_params}&bin_code=#{bin_code_params}&location_code=#{loc_code_params}"

    url = encodeURI('/admin/stock_levels?' + filter_params)
    window.location.replace url

  $('#check_all').on 'change', (e) ->
    is_all_check = $(this).is(':checked')
    cells        = datatable.cells().nodes();
    $(cells).find(':checkbox').prop('checked', is_all_check);
    check_stock_levels(is_all_check)
    return true

  $('#stock-levels .check').on 'change', ->
    is_checked = $(this).is(':checked')
    check_stock_level(is_checked, this)

  $('#assign-results').on 'click', (e) ->
    e.preventDefault()
    cells        = datatable.cells().nodes();
    stock_levels = $(cells).find(':checkbox:checked')
    stock_levels = ($(stock_level).data('id') for stock_level in stock_levels)

    tour         = $('#tour_id').val()

    $.ajax
      url: '/admin/stock_levels/process_stock_levels'
      type: 'POST'
      data:
        tour: tour
        stock_levels: stock_levels
      success: (response) ->
        if response.redirect_required == true
          window.location.replace '/admin/tours/new'
        else
          alert('Successfully Associated')
      fail: (response) ->
        alert('Something went wrong. We are notified, and will taken an action ASAP.')

  $('#tour_id').on 'change', ->
    selected_value = $(this).val()
    assign_available(undefined, selected_value)

$ ->
  Stockability.StockLevel($) if $("#page-id").hasClass('stock_levels')

