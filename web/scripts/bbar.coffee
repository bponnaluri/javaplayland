window.appendBar = (d) ->


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


    cont = document.createElement("div")
    edge = document.createElement("img")

    ref = document.createElement("img")
    select = document.createElement("img")
    sand = document.createElement("img")


    $(cont).append(ref)
    $(cont).append(select)
    $(cont).append(sand)
    $(cont).append(edge)


    rPage = ()->referencePage(90)
    $(ref).click rPage
    $(select).click codeland.showMap

    sPage = ()->sandBoxPage(90)
    $(sand).click sPage
    

    (toggleDrawerInOut)
    $(d).append(cont)

    $.get 'scripts/bbar.json',(data)->
      $(cont).css(data["cont"])
      $(edge).attr(data["edgeAttr"])
      $(edge).css(data["edgeCss"])
      $(ref).attr(data["refAttr"])
      $(ref).css(data["refCSS"])
      $(sand).css(data["sandCSS"])
      $(select).attr(data["selectAttr"])
      $(select).css(data["selectCSS"])
      #console.log(data);



