window.appendBar = (d) ->

    config=null
    $.ajax
      url: 'scripts/config/gameSelection.json',
      dataType: 'json',
      async: false,
      success: (data)->
        config=data

    toggleDrawerInOut = () ->
        cfg=config["drawerToggle"]
        if $(edge).attr("src") == cfg["inImg"]
            $(cont).animate(cfg["inAnim"])
            $(edge).attr({"src":cfg["outImg"]})
        else
            $(cont).animate(cfg["outAnim"])
            $(edge).attr({"src":cfg["inImg"]})
        return false


    cont = $('<div></div>')
    edge=$('<img></img>')

    ref =$('<img></img>')
    select=$('<img></img>')

    select =$('<img></img>')
    sand=$('<img></img>')


    $(cont).append(ref)
    $(cont).append(select)
    $(cont).append(sand)
    $(cont).append(edge)


    rPage = ()->referencePage(config["pSize"])
    $(ref).click rPage
    $(select).click codeland.showMap

    sPage = ()->sandBoxPage(config["pSize"])
    $(sand).click sPage
    

    (toggleDrawerInOut)
    $(d).append(cont)

    $(cont).css(config["cont"])
    $(edge).attr(config["edgeAttr"])
    $(edge).css(config["edgeCss"])
    $(ref).attr(config["refAttr"])
    $(ref).css(config["refCSS"])
    $(sand).css(config["sandCSS"])
    $(select).attr(config["selectAttr"])
    $(select).css(config["selectCSS"])

