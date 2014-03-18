#This file contains miscalleneous utility files.

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
playAudio = (name) ->
  sound = document.createElement("video")
  $(sound).attr({"src":"audio/"+name,"autoplay":"true"})
  return



window.playAudio=playAudio
window.findConfig=findConfig