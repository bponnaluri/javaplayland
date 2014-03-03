"use strict"

# We will update this when running JVM /Beanshell code so that we can show the user the currently executing line
window.notifyEvalSourcePosition = (startLine,startCol,endLine,endCol) ->
    ###
        Shows the user the currently executing line.
        --> Where is this function called?
    ###
    console.log startLine,startCol,endLine,endCol
    ##window.gameManager.codeEditor.editorGoToLine startLine
    return;

# Things assigned to root will be available outside this module
root = exports ? this.codeland = {}

# root.UIcont is the main div codeland has to work with.
root.UIcont = null


window.initialize = (UIcont) ->
    ###
        External Function (used by something outside of this file)

        Reads the config files, initializes Doppio, should be the first codeland function called.

        @param UICont
            A JQuery div where everything created by codeland will live.
    ###
    $('#copyrightinfo').click -> window.AboutPage()
    root.gameSelectionScrollPosition = 0

    window.setupRoot(root)

    root.loadJSONConfigs()
    root.UIcont = UIcont
    root.initializeDoppio()
    return

root.initializeDoppio = ->
    ###
        Internal Function (used only by the code in this file)

        Constructs the doppioAPI and tells it to preload the required code.
    ###
    root.doppioReady = false
    root.doppioPreloaded = false
    progress = $('#progress')
    count = 0;
    last_display = ""
    progress_cb = (ignore_incorrect_fraction) ->
        ###
            Handles the progress bar and displaying what part of Doppio is loading
            to the user.
        ###
        displayConst=391 #What does this do???
        count = count + 1
        display = Math.floor((100*count) / displayConst)
        if (display == 100)
            display = "Starting Java Virtual Machine..."
        else display = "Opening " + display
        if (last_display != display)
            last_display = display
            progress.html display
        return
    preload_cb = ->
        ###
            Once doppio has intialized, this function is called to tell
            doppio to pre-compile the functions used by the games.
        ###
        root.doppioAPI.preload root.beanshellPreload, root.wrapperCompiled_cb
        root.doppioPreloaded = true
        return
    root.doppioAPI = new DoppioApi null, preload_cb, progress_cb
    return

root.wrapperCompiled_cb = =>
    ###
        Internal Function (used only by the code in this file)

        Once doppio has finished pre-compiling, this draws the game-map
        and, should something be waiting on doppio to compile and has
        presented codeland with a callback, runs that callback.

        Note: In the current implementation, only the latest thing to
        assign a callback to codeland is run.
    ###
    root.doppioReady = true
    console.log 'Finished Preloading Doppio'
    player = root.getPlayer()
    root.drawGameMap(player)
    window.appendBar("#mainbody")
    if root.wrapperCompiledCallback?
        console.log 'Found Callback, running'
        root.wrapperCompiledCallback()
    return

root.waitForWrapper = (callback) ->
    ###
        External Function (used by something outside of this file)

        Should there be something waiting for doppio to compile, it calls
        this functions and provides a callback which will then be run when
        doppio has finished compiling.

        Note: In the current implementation, only the latest thing to
        assign a callback to codeland is run.

        @param callback
            The function to call when doppio is finished compiling.
    ###
    root.wrapperCompiledCallback = callback
    return



# FRONTEND UI
root.drawGameMap = (player) ->
    ###
        Internal Function (used only by the code in this file)

        Draws the game selection screen.

        @param player
            The player whose games to display.
    ###
    descriptions = root.getGameDescriptions()
    mapDiv = $(root.UIcont)
    mapDiv.empty()

    gameSequence = root.getGameSequence()
    sel = new gameSelector(mapDiv, false)
    tmp1 = $('id')

    count = 0
    addGameToMap = (game, questContext) ->
        count = count + 1
        console.log("Count:"+count)
        sel.buildDiv count, game, descriptions[game], player.games[game], root.canPlay(game), codeland, questContext
        return
    qcount = 0

    config=null
    $.ajax
      url: 'scripts/config/codeland.json',
      dataType: 'json',
      async: false,
      success: (data)->
        config=data

    for quest in root.quests
        span = $ '<span>', {
            title: config["questSpan"]["title"]
            alt: config["questSpan"]["alt"],
            id: "#{quest.title}"
        }
        span.css (
            config["questSpan"]["css"]
        )

        $(tmp1).append(span)
        span.append """<b>QUEST #{++qcount}: #{quest.title}</b>""" #Lavanya

        span.click (clickEvent) ->
            $("span[id='#{clickEvent.currentTarget.id} Container']").children().toggle()
            return

        games = $ '<span>', {
            id: "#{quest.title} Container"
        }

        for gameKey in quest.games
            addGameToMap gameKey, games

        jQuery(tmp1).append games
        $("<br><br>").appendTo tmp1 #Lavanya

    $(config["header"]["h1"]).prependTo tmp1
    $(config["header"]["h2"]).prependTo tmp1

    $('#gameSelection').animate {
        scrollTop: root.gameSelectionScrollPosition
    }, 0
    #TODO FADE IN
    return

root.startGame = (game) ->
    ###
        External Function (used by something outside of this file)

        Starts the given game, setting up the environment and creating the
        gameManager.

        @param game
            The game to start.
    ###
    $('#select').show() #Lavanya
    console.log("Starting #{game}")
    for quest, index in root.quests
        found = quest.games.indexOf game
        if found != -1
            root.currentQuest = root.quests[index]
            break
    root.currentGame.finishGame() if root.currentGame
    root.currentGame = null

    gamediv = $(root.UIcont)
    tmp1 = document.getElementById("gameSelection")
    if tmp1 != null
        root.gameSelectionScrollPosition = tmp1.scrollTop
        root.UIcont.removeChild(tmp1)

    #Todo FADE IN

    description = root.getGameDescriptions()[game]
    stats = root.loadGameStats(game)
    stats.openedCount++
    root.storeGameStats(game,stats)

    env = {
        key: game
        description : description
        visualMaster: root.visualMasters[game]
        frameRate: root.visualMasters[game].frameRate
        gamediv : gamediv
        player : root.getPlayer()
        codeland : this
        backEnd: description.backEnd
        gameState: description.gameState
        stats : stats
    }
    #Not used ... window.location.hash='game='+encodeURIComponent(game)
    root.currentGame = new GameManager env
    root.currentGame.startGame()
    root.currentGame.helpTips() unless env.stats.runCount > 0
    return

# Some browsers have a deepcopy function, others do not.
# For those who do not, we use the JQuery deepcopy function.
if not deepcopy?
    deepcopy = (src) -> $.extend(true, {}, src)




root.showMap = () ->
    ###
        External Function (used by something outside of this file)

        Stops the current game and draws the game selection screen.
    ###
    root.currentGame.finishGame() if root.currentGame
    root.wrapperCompiledCallback = null if root.wrapperCompiledCallback?
    root.currentGame = null
    root.drawGameMap root.getPlayer()
    $('#select').hide()
    return












