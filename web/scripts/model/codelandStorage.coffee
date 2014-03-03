# BACKEND Methods useful for all games
# How Storage Works:
# The browser has a persistant localstorage dictionary.
# We currently take data, turn it into a JSON object, and store it in this
# local storage.


root = exports ? this.codeland = {}

window.setupRoot=(root)->
  root.getString = (key) ->
    ###
        Internal Function (used only by the code in this file)

        Retrieves a string from the browser's internal storage dictionary.

        @param key
            The key for the string we are retrieving.
    ###
    return localStorage.getItem key

  root.setString = (key, value) ->
    ###
        Internal Function (used only by the code in this file)

        Sets a string in the browser's internal storage dictionary.

        @param key
            The key for the string we are storing.
            This should be a DOMString.
        @param value
            The value we want associated with the key in the browser's
            internal storage.
            This should be a DOMString.
    ###
    localStorage.setItem key, value

  root.clearString = (key) ->
    ###
        Internal Function (used only by the code in this file)

        Clears a string in the browser's internal storage dictionary.

        @param key
            The key for the string we are clearing.
            This should be a DOMString.
    ###
    localStorage.removeItem key
    return

  root.load = (key) ->
    ###
        Internal Function (used only by the code in this file)

        Retreives and parses data from the localstorage and returns it.

        @param key
            The key of the data to load.
    ###
    val = root.getString key
    return null unless val?
    result = JSON.parse val
    return result if result?
    throw new Error("Could not parse " + val)

  root.store = (key, val) ->
    ###
        Internal Function (used only by the code in this file)

        JSON-ifies the given value and stores it in the localstorage
        associated to the given key.

        @param key
            The key which which to associate the stored data.
        @param val
            The data to store.
    ###
    throw new Error("Value must exist") unless val?
    root.setString(key, JSON.stringify val)
    return

  root.loadGameStats = (gameKey) ->
    ###
        Internal Function (used only by the code in this file)

        Returns the game statistics for the game associated with gameKey.
        Returns default values for all statistics shouled the game not
        exist.

        @param gameKey
            The gameKey with which the game we want the statistics for
            is associated.
    ###
    p = root.getPlayer()
    data = p.games[gameKey] ?= {}
    #Ensure we have the minimum number of expect properties
    data.abortCount ?=0
    data.runCount ?=0
    data.winCount ?=0
    data.lostCount ?=0
    data.resetCount ?=0
    data.openedCount ?=0
    data.hiscore ?=0
    data.passed ?= false
    data.stars ?= 0
    data.tipsCount ?= 0
    return data


  #Updates the player data
  root.storeGameStats = (key, data) ->
    ###
        External Function (used by something outside of this file)

        Adds the given statistics to the game corresponding to the given
        key and saves these to the current player.

        @param key
            The key of the game whose statistics we are storing.
        @param data
            The statistics to be added to the game's data.
    ###
    throw new Error("Cannot be null") unless key? && data?
    root.updatePlayer((p) ->
      p.games[key] ?= {}
      $.extend(p.games[key],data)
    )
    return

  root.getGame = ->
    ###
        Internal Function (used only by the code in this file)

        Gets the game currently being played.
    ###
    return getPlayer().currentGame


  root.getPlayer = ->
    ###
        Internal Function (used only by the code in this file)

        Retrieves and returns the current player.
        Returns a generic player should the current player not exist.
    ###
    root.currentPlayer ?= root.load("CurrentPlayer")
    root.currentPlayer ?= {
      id : +(new Date())
      currentGame : ''
      first : ''
      last : ''
      avator : 'generic'
      games : { }
    }
    return root.currentPlayer

  root.updatePlayer = (callback) ->
    ###
        Internal Function (used only by the code in this file)

        Updates the current player.

        @param callback
            A function which is passed the current player and expected
            to change the player.
            Its return value is ignored.

            See codeland.storeGameStats for an example.
    ###
    player = root.getPlayer()
    callback(player)
    root.store("CurrentPlayer", player)
    return

  root.clearPlayer = ->
    ###
        Internal Function (used only by the code in this file)

        Clears all data bout the current player.
    ###
    root.clearString "CurrentPlayer"
    return


  root.readJSON = (theurl, cb) ->
    ###
        Internal Function (used only by the code in this file)

        Reads the json data at the given url via an ajax request.
        Passes the resulting data to the provided callback, passing
        undefined should the ajax request have failed.

        @param theurl
            The location and name of the json file.
        @param cb
            The callback function which will be passed the data from
            the json file.
    ###
    fail = false
    console.log "Reading #{theurl}"
    try
      jQuery.ajax {
        dataType: 'json',
        url: theurl,
        async: false,
        error : () ->
          fail = true
          console.log "Could not read #{theurl}"
          cb(undefined)
          return
        success: (data) ->
          cb(data)
          return
      }
    catch exception
      fail = true
      console.log "#{theurl}: #{exception} #{exception.message} #{exception.stack}"
    if(fail)
      throw "Configuration Exception reading #{theurl}"
    return

  root.loadJSONConfigs = () ->
    ###
        Internal Function (used only by the code in this file)

        Reads and parses all of the config files.
    ###
    if not root.gameDescriptions?
      root.gameDescriptions = {}
    configFail = false
    root.readJSON 'config/config.json', (data) ->
      if data == undefined
        configFail = true
      root.baseDefaults = data.defaults
      root.gameDefaults = {}
      for type in data.gameTypes
        root.readJSON "config/#{type}", (typeData) ->
          if typeData == undefined
            configFail = true
          root.gameDefaults[typeData.gameType] = typeData
          return
      root.quests = []
      root.visualMasters = {}
      root.beanshellPreload = data.beanshellPreload
      questIndex = -1
      for quest in data.quests
        root.readJSON "config/#{quest}", (questData) ->
          if questData == undefined or questData.key == undefined
            configFail = true
          ++questIndex
          root.quests[questIndex] = questData
          for game in questData.games
            root.readJSON "config/#{game}.json", (gameData) ->
              if gameData == undefined
                configFail = true
              try
                root.addToObject root.baseDefaults, gameData
                root.addToObject root.gameDefaults[gameData.gameType].defaults, gameData
                root.visualMasters[game] = root.gameDefaults[gameData.gameType].visualMaster
                root.stringifyConfigArrays gameData
                root.convertShorthandToCode gameData
                root.addHintsToCode gameData
                root.gameDescriptions[game] = gameData
                return
              catch error
                configFail = true
                console.log "#{error} #{error.message} #{error.stack}"
              return
          return
      root.currentQuest = root.quests[0]
      return
    if configFail
      root.gameDescriptions = null
      throw "Configuration Exception"
    return

  root.addToObject = (source, destination) ->
    ###
        Internal Function (used only by the code in this file)

        Recursively adds all attributes of source into
        destination.
        Does not overwrite attributes of destination.

        @param source
            The source dictionary where attributes are copied from.
        @param destination
            The destination dictionary where attributes are added to.
    ###
    for key, value of source
      if key of destination
        if typeof value == "object"
          root.addToObject value, destination[key]
      else
        destination[key] = value
    return

  root.stringifyConfigArrays = (gameData) ->
    ###
        Internal Function (used only by the code in this file)

        Converts gameData config information from arrays into newline
        deliminated strings.

        @param gameData
            The game's data.
    ###
    gameData.game.map = gameData.game.map.join '\n' if gameData?.game.map?.join?
    gameData.code.prefix = gameData.code.prefix.join '\n' if gameData?.code.prefix.join?
    if gameData.code.prefix.charAt(gameData.code.prefix.length - 1) != '\n'
      gameData.code.prefix += '\n'
    gameData.code.postfix = gameData.code.postfix.join '\n' if gameData?.code.postfix.join?
    gameData.code.initial = gameData.code.initial.join '\n' if gameData?.code.initial?.join?
    return

  root.convertShorthandToCode = (gameData) ->
    ###
        Internal Function (used only by the code in this file)

        Converts the shorthand code found in the game's json config
        to actual java code.

        @param gameData
            The game's data.
    ###
    if gameData.code.initial?
      return
    initial = ''
    shorthand = gameData.code.shorthand
    if not shorthand?
      return
    while shorthand != ''
      for short in gameData.code.shorthandKey
        re = new RegExp short.regex
        result = re.exec shorthand
        if result != null
          if initial != ''
            last = initial.substring(initial.length - 1)
            if last == ';'
              initial += '\n'
            else if last != '\n'
              initial += '();\n'
          initial += short.repl
          break
      if result == null
        result = /\(.*?\)/.exec shorthand
        if result != null
          initial += result[0] + ';'
      if result != null
        shorthand = shorthand.substring result[0].length
      else
        shorthand = shorthand.substring 1
    if initial != '' && initial.substring(initial.length - 1) != ';'
      initial += '();'
    gameData.code.initial = initial
    return

  root.addHintsToCode = (gameData) ->
    ###
        Internal Function (used only by the code in this file)

        Takes the hints found in the comments array in the json config of
        the game and places them as java-style comments in the game's code.

        @param gameData
            The game's data.
    ###

    gameData.code.initial ?= ''
    if gameData.code.comments
      one = '// '+ ((gameData.code.comments.join('\n')).replace(/\n/g,'\n// '))+ '\n'
      if gameData.code.prefix.length > 1
        gameData.code.prefix = one + gameData.code.prefix
      else
        gameData.code.initial = one + '\n' + gameData.code.initial
    return


  root.getGameDescriptions = ->
    ###
        Internal Function (used only by the code in this file)

        Returns the game descriptions, loading from the json config
        files if the descriptions do not already exist.
    ###
    if root.gameDescriptions?
      return root.gameDescriptions
    root.loadJSONConfigs()
    return root.gameDescriptions

  root.getGameSequence = ->
    ###
        Internal Function (used only by the code in this file)

        Returns the sequence of all of the games, creating it should
        it not already exist.
    ###
    return root.gameSequence if root.gameSequence
    root.gameSequence = []
    games = root.getGameDescriptions()
    addGame = (name) =>
      return if $.inArray(name, root.gameSequence) != -1
      doFirst = games[name].depends ?= []
      addGame g for g in doFirst
      root.gameSequence.push name
      return
    addGame(g) for g, ignored of games
    return root.gameSequence

  root.canPlay = (game) ->
    ###
        Internal Function (used only by the code in this file)

        Returns whether or not the current player can play the
        given game.

        @param game
            The game we are checking.
    ###
    player = root.getPlayer()
    # If already completed then no need to check dependencies
    return true if player?.games[game]?.passed

    depends = root.getGameDescriptions()[game]?.depends
    return true unless depends
    passCount = 0
    # Count number of dependencies that have completed
    #( (g)-> passCount++ if player?.games[g]?.passed )(g) for g in depends

    passCount++ for g in depends when player?.games[g]?.passed
    return passCount == depends.length
