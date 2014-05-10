$ ->
  $(document).on 'reset', '.mighty-grid-filter', (e) ->
    $(e.target).find('[type="hidden"].clear_required').val('')
    url = window.location.href.split('?')
    if url.length > 1
      window.location.replace(url[0])