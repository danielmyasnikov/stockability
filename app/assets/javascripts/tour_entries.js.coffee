
Stockability = {}

Stockability.TourEntry = ($) ->

  $('.assign-tour').select2
    theme: 'bootstrap'

$ ->
  Stockability.TourEntry($) if $("#page-id").hasClass('tour_entries')



