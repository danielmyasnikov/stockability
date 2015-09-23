Stockability = {}

Stockability.StockLevel = ($) ->
  $('#filter').click (e) ->
    e.preventDefault()
    sku_params =      $('#sku_filter').val()           || []
    bin_code_params = $('#bin_code_filter').val()      || []
    loc_code_params = $('#location_code_filter').val() || []

    sku_params      = sku_params?.join(',')
    bin_code_params = bin_code_params?.join(',')
    loc_code_params = loc_code_params?.join(',')
    filter_params = "sku=#{sku_params}&bin_code=#{bin_code_params}&location_code=#{loc_code_params}"

    url = encodeURI('/admin/stock_levels?' + filter_params)
    window.location.replace url

$ ->
  Stockability.StockLevel($) if $("#page-id").hasClass('stock_levels')

