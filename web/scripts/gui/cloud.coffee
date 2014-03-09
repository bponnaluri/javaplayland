
window.playAudio = (name) ->
	sound = document.createElement("video")
	$(sound).attr({"src":"audio/"+name,"autoplay":"true"})
	return

window.objCloud = (dim,par,obj,x,y,tscale,ng,man) ->

    cssData=null
    $.ajax
      url: 'scripts/config/cloud.json',
      dataType: 'json',
      async: false,
      success: (data)->
        cssData=data

    tipnum = 0
    resizeCloud = () ->
        cloudWidth = $(window).width()/2
        cloudHeight = $(window).height()/2
        textWidth = "80%"
        textHeight = "80%"
        $(cloud).css "align", "middle"
        $(cloud).css "width", cloudWidth
        $(cloud).css "height", cloudHeight
        $(text).css "text-align", "center"
        $(text).css "width", textWidth
        $(text).css "height", textHeight
        $(text).css "top", "30%"
        $(text).css "left", "10%"

    rb = () ->
        if tipnum != par.length - 1
            tipnum++
        
        text.innerHTML = "<p style='margin-top:auto;margin-right:auto'>"+par[tipnum]+"</p>"

        if tipnum == par.length - 1
            $(ntr).attr(cssData["rArrowAttr"])

    lb = () ->
        if tipnum != 0
            tipnum--
        
        text.innerHTML = "<p style='margin-top:auto;margin-right:auto'>"+par[tipnum]+"</p>"
        if tipnum == 0
            $(ntl).attr(cssData["lArrowAttr"])

    cont = $('<div></div>')
    text = $('<div></div>')
    cloud = $('<div></div>')
    xb = $('<div></div>')
    xbcloud = $('<div></div>')
    subbd = $('<div></div>')
	
    if par.length > 1
        ntc = $('<div></div>')
        nti = $('<div></div>')
        ntl = $('<div></div>')
        ntr = $('<div></div>')

        $(ntc).css({"position":"absolute","z-index":"310","bottom":"-10%","right":"-5%","width":dim/2,"height":dim/7})
        $(nti).attr(cssData["ntiAttr"])
        $(nti).css(cssData["ntiCSS"])

        $(ntl).attr(cssData["ntlAttr"])
        $(ntl).css(cssData["ntlCSS"])
        $(ntr).attr(cssData["ntrAttr"])
        $(ntr).css(cssData["ntrCSS"])

        $(ntc).append(nti)
        $(ntc).append(ntl)
        $(ntc).append(ntr)
        $(cont).append(ntc)

        $(ntr).click(() -> rb())
        $(ntr).hover(
            () -> if(tipnum != par.length - 1) then $(ntr).attr(cssData["rArrowHighAttr"])
            () -> $(ntr).attr(cssData["rArrowAttr"])
        )

        $(ntl).click(() -> lb())
        $(ntl).hover(
            () -> if(tipnum != 0) then $(ntl).attr(cssData["rArrowHighAttr"])
            () -> $(ntl).attr(cssData["lArrowAttr"])
        )
		
    if obj = "body"
        backdrop = document.createElement("div")
        $(backdrop).css(cssData["backdropCSS"])
        $(obj).append(backdrop)
        $(backdrop).click(() -> $(cont).remove();$(backdrop).remove())

    if ng != "none"
        ngco = $('<div></div>')
        ngi = $('<img></img>')
        ngt = $('<div></div>')
        $(ngco).css({"position":"absolute","z-index":"310","bottom":"0%","right":"0%","width":dim/2,"height":dim/7})
        $(ngi).attr(cssData["ngiAttr"])
        $(ngi).css(cssData["ngiCSS"])
        $(ngt).css({"position":"absolute","z-index":"302", "top":"35%","text-align":"center","height":dim/10,"width":"100%"})
        ngt.innerHTML = "Next Game!"
        $(ngco).append(ngi)
        $(ngco).append(ngt)
        $(cont).append(ngco)

        $(ngco).click(() -> man.finishGame();codeland.startGame(ng);$(cont).remove();$(backdrop).remove())

    $(subbd).css({"position":"absolute","top":"0%","right":"0%","width":dim/8,"height":dim/8})
    $(xbcloud).attr(cssData["xbcloudAttr"])
    $(xbcloud).css(cssData["xbcloudCSS"])
    $(xb).attr(cssData["xbAttr"])
    $(xb).css(cssData["xbCSS"])
     
    $(cloud).attr({"src":"img/interface/cloud.png","align":"middle","width":$(window).width()/2,"height":$(window).height()/2}) #Lavanya
    $(cont).css({"position":"absolute","top":x,"left":y,"z-index":"297"})
    $(text).css(cssData["textCSS"])

    $(cont).append(cloud)
    $(cont).append(text)
    $(window).resize(resizeCloud)
    $(cont).append(subbd)
    $(subbd).append(xbcloud)
    $(subbd).append(xb)

    $(obj).append(cont)
    text.innerHTML = "<p style='margin-top:auto;margin-right:auto'>"+par[0]+"</p>"
    $(text).css({'font-size':(dim*.05*tscale) + 'px'})
    # Width is 75%, leaving 25% left to play with
    left=0.125*dim
    $(text).css({"left":left+"px"})
    #Removed vertical centering - looks better without it


    $(xb).click(() -> $(cont).remove();$(backdrop).remove())

    return


