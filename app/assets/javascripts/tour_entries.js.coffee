Stockability = {}

Stockability.TourEntry = ($) ->

  ERROR_MSG = "Something went wrong. We are notified and will try to fix the issue ASAP"

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

  $('#assign-tour').click (e) ->
    e.preventDefault()

    tour_id = $('#select-tour').val()

    if (tour_id == "")
      alert('No tour selected. Please select tour for entries')
      return false

    cells               = datatable.cells().nodes();
    tour_entries        = $(cells).find('.check:checkbox:checked')
    tour_entries_params = ($(tour_entry).data() for tour_entry in tour_entries)

    $.ajax
      url: '/users/tour_entries/assign_tour'
      method: 'POST'
      data: 
        tour_id:      tour_id
        tour_entries: tour_entries_params
      success: (data) ->
        alert('Entries are assigned to tour')

  $('#reject-selected').click (e) ->
    e.preventDefault()

    cells        = datatable.cells().nodes();
    tour_entries = $(cells).find('.check:checkbox:checked')
    tour_entries_params = ($(tour_entry).data() for tour_entry in tour_entries)

    $.ajax
      url: '/users/tour_entries/reject_variance'
      method: 'PUT'
      data:
        tour_entries: tour_entries_params
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
    tour_entries_params = ($(tour_entry).data() for tour_entry in tour_entries)

    $.ajax
      url:    '/users/tour_entries/adjust_variance'
      method: 'PUT'
      data:
        tour_entries: tour_entries_params
      success: (data) ->
        # returns an array of array, where nested array is [tour_entry.id, tour_entry.stock_level_qty]
        alert("Stock Level is adjusted")
        window.location.href = window.location.href
      fail: (e) ->
        alert(ERROR_MSG)

  $('.adjust-tour-entries').click (e) ->
    e.stopPropagation()
    e.preventDefault()

    $this  = $(this)
    url    = $this.attr('href')
    method = $this.data('method')

    $.ajax
      url:    url
      method: method
      success: (data) ->
        alert('yay')

  $('.reject-tour-entries').click (e) ->
    e.stopPropagation()
    e.preventDefault()

    $this  = $(this)
    url    = $this.attr('href')
    method = $this.data('method')

    $.ajax
      url:    url
      method: method
      success: (data) ->
        alert('yay')

$ ->
  Stockability.TourEntry($) if $("#page-id").hasClass('tour_entries')
