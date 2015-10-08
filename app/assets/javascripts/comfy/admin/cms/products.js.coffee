Stockability = {}

Stockability.ProductsImport = ($) ->
  $('#import').attr('disabled', 'disabled');
  $('#file').on 'change', ->
    $('#import').removeAttr('disabled');

$ ->
  Stockability.ProductsImport($) if $("#page-id").hasClass('products_import')
