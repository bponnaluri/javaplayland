class window.gameSelector
  cont = null
  config=null
  constructor: (@div, @dis) ->
    $("#acelne").remove()
    cssData=null
    $.ajax
      url: 'scripts/config/gameSelection.json',
      dataType: 'json',
      async: false,
      success: (data)->
        cssData=data
    config=cssData
    tmp=$('<div></div>')
    cont = $(tmp)
    $(tmp).css(config["tmpCSS"])
    $(tmp).attr("id","gameSelection")
    @div.append(tmp)
    return

  buildDiv: (count, game, desc, player, canPlay, codeland) ->

    span = document.createElement("span")
    $(span).css(config["spanCSS"])

    $(span).attr("id","select#{game}")
    cont.append(span)

    src = 'img/stare.png'

    $(span).click(-> codeland.startGame(game) )
    #            $(span).append count + ' '
    $(span).append  desc.title
    if player?.passed is true
      src = 'img/star.png'
      img = $ '<img>', {
        id: 'star',
        src: src,
        style: 'max-height:16px',
        alt: "Start Game"

      }
      $(span).append img.get 0

#            @buildAn(tmp1,canPlay)
#            @buildScore(tmp1,player)
#            @buildInfo(tmp1,desc)
#            @canPlay(tmp1,canPlay, codeland, game)

  buildAn: (con,canPlay) ->
    tmp2 = $('<img></img>')
    $(con).append(tmp2)
    $(tmp2).css(config["tmp2CSS"])
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
    tmp = $('<div></div>')
    $(con).append(tmp)
    $(tmp).css(config["tmpBuildScoreCSS"])

    tmp1 = $('<p></p>')
    tmp2 = $('<p></p>')
    tmp3 = $('<p></p>')

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
    tmp = $('<div></div>')
    $(con).append(tmp)
    $(tmp).css(cssData["tmpBuildInfoCSS"])

    tmp1 = $('<p></p>')
    tmp2 = $('<p></p>')

    $(tmp).append(tmp1)
    $(tmp).append(tmp2)

    $(tmp1).text("Name:  #{desc.name}")
    $(tmp2).text("Description:  #{desc.description}")


  canPlay: (con, cp, codeland, game) ->
    if cp
      $(con).click( -> codeland.startGame(game) )
    else
      ovr = $('<div></div>')
      $(con).prepend(ovr)
      $(ovr).css(cssData["tmpOverCSS"])