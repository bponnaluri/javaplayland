window.appendBar = (d) ->

  $("#acelne").remove()
  cssData=null
  $.ajax
    url: 'scripts/config/menuBar.json',
    dataType: 'json',
    async: false,
    success: (data)->
      cssData=data

  toggleDrawerInOut = () ->
    if $(edge).attr("src") == "img/barin.png"
      $(cont).animate({"left":"0px"})
      $(cont).animate({"left":"-10px"})
      $(edge).attr({"src":"img/barout.png"})
    else
      $(cont).animate({"left":"0px"})
      $(cont).animate({"left":"-150px"})
      $(edge).attr({"src":"img/barin.png"})
    return false


  cont = $('<div></div>')
  edge = $('<img></img')

  ref = $('<img></img>')
  select=$('<img></img>')
  sand=$('<img></img>')

  $(cont).css(cssData["cont"])
  $(edge).attr(cssData["edgeAttr"])
  $(edge).css(cssData["edgeCSS"])

  $(ref).attr(cssData["refAttr"])
  $(ref).css(cssData["refCSS"])
  $(sand).attr(cssData["sandAttr"])
  $(sand).css(cssData["sandCSS"])
  $(select).attr(cssData["selectAttr"])
  $(select).css(cssData["selectCSS"])

  $(cont).append(ref)
  $(cont).append(select)
  $(cont).append(sand)
  $(cont).append(edge)

  $(ref).click referencePage
  $(select).click codeland.showMap
  $(sand).click sandBoxPage

  #$(cont).children().click(toggleDrawerInOut)
  $(toggleDrawerInOut)

  $(d).append(cont)