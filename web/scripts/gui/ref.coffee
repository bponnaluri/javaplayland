window.inject = (d) ->

  $.ajax
    url: 'scripts/config/refUIData.txt',
    dataType: 'json',
    async: false,
    success: (data)->
	    d.innerHTML = data