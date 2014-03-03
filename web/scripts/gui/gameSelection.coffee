class window.gameSelector
    cont = null
    cssData=null
    constructor: (@div, @dis) ->
        $("#acelne").remove()
        tmp = document.createElement("div")
        cont = $(tmp)

        dData=null

        $.ajax
          url: 'scripts/config/gameSelection.json',
          dataType: 'json',
          async: false,
          success: (data)->
            dData=data

        cssData=dData
        $(tmp).css(cssData["tmpCSS"])
        $(tmp).attr(cssData["tmpAttr"])
        @div.append(tmp)
        return

    buildDiv: (count, game, desc, player, canPlay, codeland, questContext) -> #Coded by Lavanya
        span = $('<span></span>')
        $(span).css(cssData["spanCSS"])

        $(span).attr("id","select#{game}")
        $(span).attr("class","select#{count}")
        questContext.append(span)

        $(span).click(-> codeland.startGame(game) )
        if player?.passed is true
            $(span).append """<b><font color="white">#{count}: #{desc.title}</font></b> """ #Coded by Lavanya
            src = 'img/star.png'
            img = $ '<img>', {
                id: 'star',
                src: src,
                style: 'max-height:16px',
                alt: "Start Game"
            }
            $(span).append img.get 0
        else
            $(span).append """<font color="white">#{count}: #{desc.title}</font>""" #Coded by Lavanya

    buildAn: (con,canPlay) ->
        tmp2 = $('<img></img>')
        $(con).append(tmp2)
        $(tmp2).css(cssData["tmp2CSS"])
        derp = () ->
            if $(tmp2).attr("src") is "img/wmn1_fr1.gif"
                $(tmp2).attr("src","img/wmn1_fr2.gif")
            else
                $(tmp2).attr("src","img/wmn1_fr1.gif")
        if canPlay
            setInterval(derp,450)
        else
            $(tmp2).attr("src","img/wmn1_fr1.gif")

    buildScore: (con,player) ->
        tmp = document.createElement("div")
        $(con).append(tmp)
        $(tmp).css(cssData["tmpBuildInfoCSS"])
        tmp1 = document.createElement("p")
        tmp2 = document.createElement("p")
        tmp3 = document.createElement("div")

        $(tmp).append(tmp1)
        $(tmp).append(tmp2)
        $(tmp).append(tmp3)

        if player?.passed is true
            $(tmp1).text("Status:  Complete")
        else
            $(tmp1).text("Status:  Incomplete")

        $(tmp2).text("Hi-Score: #{if player? then player.hiscore else 0}")

        if @dis
            $(tmp3).text("Stars: #{player?.stars}")
        else
            for ns in [1..player?.stars] by 1
                $(tmp).append("<img src='img/star.png' width='20%' height='20%'></img>")
            for es in [player?.stars...3] by 1
                $(tmp).append("<img src='img/stare.png' width='20%' height='20%'></img>")
        return

    buildInfo: (con,desc) ->
        tmp = document.createElement("div")
        $(con).append(tmp)
        $(tmp).css(cssData["tmpBuildInfoCSS"])

        tmp1 = document.createElement("p")
        tmp2 = document.createElement("p")

        $(tmp).append(tmp1)
        $(tmp).append(tmp2)

        $(tmp1).text("Name:  #{desc.name}")
        $(tmp2).text("Description:  #{desc.description}")


    canPlay: (con, cp, codeland, game) ->
        if cp
            $(con).click( -> codeland.startGame(game) )
        else
            ovr = document.createElement("div")
            $(con).prepend(ovr)
            $(ovr).css(cssData["overCSS"])
