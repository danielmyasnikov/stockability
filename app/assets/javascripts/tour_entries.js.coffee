
Stockability = {}

Stockability.TourEntry = ($) ->

  $('.assign-tour').select2
    theme: 'bootstrap'

  $('#datatable-simple').DataTable
    searching:  false
    ordering:   true
    processing: true
    paging:     false

$ ->
  Stockability.TourEntry($) if $("#page-id").hasClass('tour_entries')



