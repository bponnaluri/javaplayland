
#Synchronously loads the config file
findConfig=(loc)->
  cssData=null
  $.ajax
    url: loc,
    dataType: 'json',
    async: false,
    success: (data)->
      cssData=data
  return cssData


#Play audio


window.findConfig=findConfig