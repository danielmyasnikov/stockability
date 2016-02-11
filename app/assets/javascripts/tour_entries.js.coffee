Stockability = {}

Stockability.TourEntry = ($) ->

  ERROR_MSG = "Something went wrong. We are notified and will try to fix the issue ASAP"

  $('#assign-tour').click (e) ->
    e.preventDefault()

    tour_id = $('#select-tour').val()

    if (tour_id == "")
      alert('No tour selected. Please select tour for entries')
      return false


    cells        = datatable.cells().nodes();
    tour_entries = $(cells).find('.check:checkbox:checked')
    tour_entries = ($(tour_entry).data('id') for tour_entry in tour_entries)

    $.ajax
      url: '/users/tour_entries/assign_tour'
      method: 'POST'
      data:
        id:      tour_entries
        tour_id: tour_id
      success: (data) ->
        for entry in data.entries
          $tour = $("[data-id=#{entry[0]}]").parents('tr').children('.tour').children('.tour_name')
          $tour.html(entry[1])
          $tour.attr('href', "/users/tours/#{entry[2]}")

        alert('Entries are assigned to tour')

  $('.assign-tour').select2
    theme: 'bootstrap'

  $('#check_all').click (e) ->
    $el = $(e.target)
    if ($el.prop("checked"))
      $('.check').prop('checked', 'checked')
    else
      $('.check').prop('checked', false)

  datatable = $('#datatable-simple').DataTable
    searching:  false
    ordering:   true
    paging:     false

  $('#reject-selected').click (e) ->
    e.preventDefault()

    cells        = datatable.cells().nodes();
    tour_entries = $(cells).find('.check:checkbox:checked')
    tour_entries = ({ stock_level_id: $(tour_entry).data('stock-level-id'), tour_id: $(tour_entry).data('tour-id')} for tour_entry in tour_entries)

    console.log('tour_entries', tour_entries);

    $.ajax
      url: '/users/tour_entries/reject_variance'
      method: 'PUT'
      data:
        id: tour_entries
      success: (data) ->
        # returns an array of array, where nested array is [tour_entry.id, tour_entry.stock_level_qty]
        alert("Stock Level is adjusted")
        window.location.href = window.location.href
      fail: (e) ->
        alert(ERROR_MSG)


  $('#adjust-selected').click (e) ->
    e.preventDefault()

    cells        = datatable.cells().nodes();
    tour_entries = $(cells).find('.check:checkbox:checked')
    tour_entries = ({ stock_level_id: $(tour_entry).data('stock-level-id'), tour_id: $(tour_entry).data('tour-id')} for tour_entry in tour_entries)

    console.log('tour_entries', tour_entries);

    $.ajax
      url:    '/users/tour_entries/adjust_variance'
      method: 'PUT'
      data:
        id: tour_entries
      success: (data) ->
        # returns an array of array, where nested array is [tour_entry.id, tour_entry.stock_level_qty]
        alert("Stock Level is adjusted")
        window.location.href = window.location.href
      fail: (e) ->
        alert(ERROR_MSG)


$ ->
  Stockability.TourEntry($) if $("#page-id").hasClass('tour_entries')



