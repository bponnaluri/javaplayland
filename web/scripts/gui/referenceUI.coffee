root = exports ? referencePage = {}

editorCount = 0


#This class represents the sandbox used to run Java code.
class sandBoxInfo 

    backFade = null
    refContainer = null
    input= null
    output= null
    pageSize= 0
    cssData=null

    constructor: (pSize) ->
        pageSize= pSize
        dData=null
        console.log("Starting")
        cssData=findConfig('scripts/config/referenceUI.json')


    '''
    This sets up the IO area.
    @param pageSize Represents the size of the window.
    '''
    setupInput: () ->
        vSize= pageSize+"%"  #The vertical size of each panel.
        hSize = pageSize/2+"%" #The horizontal size of each panel.
        input=$('<div></div>')
        output=$('<div></div>')   
        $(input).css({width:''+hSize,height:''+vSize,position:'absolute',left:'3.3%',top:'5%','border':'1px solid black'})
        $(output).css({width:''+hSize,height:''+vSize,"padding-left":"1%",position:'absolute',right:'3.3%',top:'5%','border':'1px solid black',"overflow":"auto"})

    ''' 
    This sets up the reference container.
    @param pageSize Represents the size of the reference container.
    '''
    setupRefContainer: ()->
        pSize= pageSize+"%"
        refContainer = $('<div></div>')
        $("body").prepend(refContainer)
        $(refContainer).css({width:''+pSize,height:''+pSize,left:'5%',top:'5%',position:'absolute','z-index':'301','background-color':'#FFFFFF'})
        return

    #Add the IO area to the page
    addIO: ()->
        $(refContainer).prepend(input)
        $(refContainer).prepend(output)

    setupBackFade: () ->
        backFade = $('<div></div>')
        $(backFade).css(cssData["backFadeCSS"])
        $("body").prepend(backFade)
        $(backFade).attr({id:'bF'})

    setupEnlarge: () ->
        en1=$('<img></img>')
        en2=$('<img></img>')
        $(en1).attr({'src':'img/interface/enlarge1.png',class:'en'})
        $(en2).attr({'src':'img/interface/enlarge1.png',class:'en'})
        $(en1).css(cssData["en1CSS"])
        $(en2).css(cssData["en2CSS"])
        $(input).append(en1)
        $(output).append(en2)

    #These are accessor methods for getting divs.
    getInput: () ->
        return input          

    getOutput: () ->
        return output

    getBackFade: () ->
        return backFade

    getRefContainer: () ->
        return refContainer

'''This method adds a Java sandbox to the current page and returns information about it.
   @param pageSize Represents the size of the input and output areas on the display panel.
'''
window.sandBoxPage = (pageSize) ->


    sPanel= new sandBoxInfo(pageSize)
    sPanel.setupInput()
    sPanel.setupBackFade(300)
    sPanel.setupRefContainer()
    sPanel.addIO()
    sPanel.setupEnlarge()

    enOutHover = () ->
        this.src = 'img/interface/enlarge2.png'
    enInHover = () ->
        this.src = 'img/interface/enlarge1.png'
    enClick = () ->  #This function is called when you want to enlarge the sandbox output
        console.log("Making larger")
        $(this).unbind()

        $(this).parent().stop()
        $(this).parent().siblings().stop()

        this.src = 'img/interface/shrink1.png'
        $(this).parent().animate({width:'90%',height:'90%'})
        $(this).parent().siblings().animate({width:'0%',height:'0%',opacity:'0'})

        $(".en").hover(clHover,cllvHover)
        $(".en").click(clClick)
    closeClick = () ->
        console.log("Making smaller")
        $(backFade).remove()
        $(refContainer).remove()
        codeland.doppioAPI.abort()
    clClick = () ->
        $(this).unbind()

        $(input).stop()
        $(output).stop()

        $(input).animate({width:'45%',height:'90%',opacity:'1'})
        $(output).animate({width:'45%',height:'90%',opacity:'1'})

        $(".en").hover(enOutHover,enInHover)
        $(".en").click(enClick)
    clHover = () ->
        this.src = 'img/interface/shrink2.png'
    cllvHover = () ->
        this.src = 'img/interface/shrink1.png'

    $(".en").hover(enOutHover,enInHover)
    $(".en").click(enClick)
    $("#bF").click(closeClick)

    samplecode=[
        "////Write your Java statements here",
        "int answer = 6*7;",
        "print(answer);",
        "String text=\"Hello World\";",
        "text = text.toUpperCase();",
        "for(int i=10;i>0;i--) {",
        "\tprint(i);",
        "}",
        "String ello = text.substring(1, text.length()); // Drop first character",
        "print(text);",
        "print(ello);",
        "int[] array = new int[] {2,3,5,7,11,13};",
        "print(array);"
    ].join('\n')

    setUpJavaSandbox sPanel.getInput(), sPanel.getOutput(), samplecode
    return sPanel

'''This method adds a panel containing an introduction to Java to the page.
   @param size Represents the size of the display panel.
'''
window.referencePage = (pageSize) ->

    
    sPanel= new sandBoxInfo(pageSize)
    sPanel.setupRefContainer()
    sPanel.setupBackFade()

    $("body").prepend(backFade)
    $(backFade).attr({id:'bF'})
    $("body").prepend(refContainer)

    ref = document.createElement("div")

    pSize= pageSize+"%"
    ref = $('<div></div>')
    $(ref).css({width: "10%",height: "10%",position:'absolute',right:'5%',top:'5%','border':'1px solid black',"overflow":"auto"})



    inject(ref)

    examples = $(ref).children(".ex")


    $(sPanel.getRefContainer()).prepend(ref)


    closeClick = () ->
        $(backFade).remove()
        $(refContainer).remove()
        codeland.doppioAPI.abort()

    
    $("#bF").click(closeClick)

    for sel in [0...examples.size()]
        setUpExample(examples.eq(sel))

    return sPanel

setUpExample = (dive) ->
    text = $(dive).text()
    $(dive).empty()
    i = $('<div></div>')
    o = $('<div></div>')

    $(i).attr({"class":"ei"})
    $(o).attr({"class":"eo"})

    $(dive).append(i)
    $(dive).append(o)

    setUpJavaSandbox(i,o,text)

setUpJavaSandbox = (input, output, texti) ->
    ###
        Sets up the code editor and the doppio api for running Java code.
    ###
    input = $(input)
    output = $(output)
    textOutput = $('<div ></div>')
    output.append textOutput.get 0
    textOutput.css {"white-space": "pre-line","font-family": "monospace","overflow":"auto"}
    input.append '<div id="javasandboxsource'+editorCount+'"></div>'
    sandBoxEditor = new PlayerCodeEditor \
        'javasandboxsource'+editorCount, # editorDivId
        null,                            # commands
        texti,                           # codeText
        false,                           # wrapCode
        "",                              # codePrefix
        "",                              # codeSuffix
        null,                            # hiddenSuffix
        true,                            # freeEdit
        null                            # interpreter
    editorCount++
    # See http://stackoverflow.com/questions/11584061/automatically-adjust-height-to-contents-in-ace-cloud9-editor

    msg = ""
    stdout = (str) ->
        msg += str
        textOutput.text msg
        return
    log = (mesg) -> console.log mesg


    run = $ '<img>', {
        id: 'runCode'+editorCount,
        src: 'img/freeware/button_play_green-48px.png',
        css: {'max-height':'19%', 'display':'block', 'min-height': '24px'},
        alt: 'Run Button',
        title:'Run the program',
        click: (e) ->
            textOutput.text 'Running...'
            $(this).hide()
            $(this).siblings("img").show()

            msg = ''
            finished_cb = =>
                #Ensure "Running..." is removed even if nothing was printed by the Java program
                stdout('')
                $(this).show()
                $(this).siblings("img").hide()
            codeland.doppioAPI.abort()
            codeland.doppioAPI.setOutputFunctions stdout, log
            srcText  = sandBoxEditor.getStudentCode()
            if(srcText.indexOf("class") != -1)
                stdout('Classes are not yet supported by our Web-based Java')
                finished_cb()
            else
                codeland.doppioAPI.run(srcText,null, finished_cb)

            e.preventDefault()
            return
    }
    abort = $ '<img>', {
        id: 'abortCode'+editorCount,
        src: 'img/freeware/button_stop_red-48px.png',
        css: {'max-height':'19%', 'display':'block', 'min-height': '24px'},
        alt: 'Abort Button',
        title: 'Stop the currently running program',
        click: (e) ->
            aborted = =>
                stdout("Stopped")
                $(this).siblings("img").show()
                $(this).hide()
            codeland.doppioAPI.abort(aborted)
            e.preventDefault()
            return
    }
    abort.hide()
    input.append run.get 0
    input.append abort.get 0
    return


window.AboutPage = () ->

	closeClick = () ->
    $(backFade).remove()
    $(refContainer).remove()


    backFade = $('<div></div>')
    refContainer = $('<div></div>')

    $(backFade).css({width:'100%',height:'100%',position:'absolute','z-index':'300','background-color':'#000000','opacity':'.5'})
    $(refContainer).css({ width:'60%',height:'60%',left:'30%',top:'30%',position:'absolute','z-index':'301','background-color':'#FFFFFF'})

    $("body").prepend(backFade)
    $(backFade).attr({id:'bF'})
    $("body").prepend(refContainer)

    header = $('<div></div>')
    para = $('<div></div>')

    $(header).css({"position":"static","overflow":"auto","font-size":"26px","width":"100%","left":"25%","text-align":"center"})
    $(para).css({"overflow":"auto","max-height":"75%","position":"static"})

    header.innerHTML = "Legal Terms and Attributions"
    para.innerHTML = "
        Copyright (C) 2013 The Board of Trustees at the University of Illinois
    <br/>
        Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the \"Software\"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
    <br/>
        The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
    <br/>
        THE SOFTWARE IS PROVIDED \"AS IS\", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
<hr>


    <em>Third-party open-source content</em><br/>
    Sounds from freesound and images from openclipart.org are licensed under <a href='http://creativecommons.org/publicdomain/zero/1.0/''>the creative commons 0 license</a>
    ('game over','level completed' sounds; 'book', 'star' and treasure map icons)<br />
    The Doppio jvm license is available <a href='https://github.com/int3/doppio/blob/master/LICENSE'>here</a>.<br/>
    Last Guardian Sprites by Philipp Lenssen are licensed under the Creative Commons <a href='http://creativecommons.org/licenses/by/3.0/'> attribution license</a>.<br/>
    The yellow arrow icon by Jack Cai and the grey keyboard icon by The Working Group downloaded from findicons.com is licensed under <a href='http://creativecommons.org/licenses/by-nd/2.5/'>Creative Commons Attributions no Derivatives</a>
    <hr>

    <em>Acknowledgements</em><br>
    We wish to thank Holly, Maggie and Abby and the other participants at the 2013 University of Illinois Computer Science Summer G.A.M.E.S Camp for their game ideas, feedback and testing.
    <br>
    We wish to thank CJ Carey, John Vilk and the other developers of Doppio-JVM (a project by the <a href='http://plasma.cs.umass.edu/'>Plasma research group at UMass</a>)</a> and BrowserFS for use of their software and their support of this project.<br>
    <em>Software development and bug contribution</em><br>
	<br>
    Original software created by University of Illinois students and faculty, Chris Liu, Fabian Junge, James Kelly and Lawrence Angrave.
    <br/>
    "

	$(refContainer).append(header)
	$(refContainer).append(para)
	$("#bF").click(closeClick)





