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
        input=makeDiv(null,null)
        output=makeDiv(null,null)
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
        backFade=makeDiv({id:'bF'},cssData["backFadeCSS"])
        $("body").prepend(backFade)

    setupEnlarge: () ->
        en1=makeImgElem({'src':'img/interface/enlarge1.png',class:'en'},cssData["en1CSS"])
        en2=makeImgElem({'src':'img/interface/enlarge1.png',class:'en'},cssData["en2CSS"])
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
window.sandBoxPage = () ->

    pageSize=90
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
        $(sPanel.getBackFade()).remove()
        $(sPanel.getRefContainer()).remove()
        codeland.doppioAPI.abort()
    clClick = () ->
        $(this).unbind()

        $(sPanel.getInput()).stop()
        $(sPanel.getOutput()).stop()

        $(sPanel.getInput()).animate({width:'45%',height:'90%',opacity:'1'})
        $(sPanel.getOutput()).animate({width:'45%',height:'90%',opacity:'1'})

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
   InnerHTML is set in this method because setting it in another file did not work, there were problems with runnable code
'''
window.referencePage = () ->
  backFade = document.createElement("div")
  refContainer = document.createElement("div")

  $(backFade).css({width:'100%',height:'100%',position:'absolute','z-index':'300','background-color':'#000000','opacity':'.5'})
  $(refContainer).css({width:'90%',height:'90%',left:'5%',top:'5%',position:'absolute','z-index':'301','background-color':'#FFFFFF'})

  $("body").prepend(backFade)
  $(backFade).attr({id:'bF'})
  $("body").prepend(refContainer)

  ref = document.createElement("div")

  $(ref).css({width:'90%',height:'90%',position:'absolute',right:'5%',top:'5%','border':'1px solid black',"overflow":"auto"})

  ref.innerHTML = '<h1>A short introduction to Java (Draft Version!)</h1>
  <p class="rp">&nbsp;&nbsp;&nbsp;&nbsp;By undergraduate CS students at the University of Illinois at Urbana Champaign (UIUC).</p>
      
  <p class="rp">&nbsp;&nbsp;&nbsp;&nbsp;When first looking at <tt>code</tt>, it can be very confusing and disorienting because it is so different from conventional human language.  Once you understand your first language, picking up another will be considerably easier, and something you may have to do quickly and often if you program professionally.  In these regards, <tt>Java</tt> is no different.</p>
  
  <p class="rp">&nbsp;&nbsp;&nbsp;&nbsp;To help you get acquainted with reading and writing scripts, there will be code snippets and examples in boxes littered throughout this text that you can compile and run by clicking the little button beneath them.  To start out, these boxes will not contain real code, but something called <tt>pseudocode</tt>.  <tt>Pseudocode</tt> is halfway between a real programming language and a normal human language, it allows us to plan out and understand computer logic in an easier to read format.  Read further and the <tt>pseudocode</tt> examples will be replaced more and more by actual code as you learn about <tt>Java.</tt></p>
  
  <h2>Basic Formatting</h2>
  <p class="rp">&nbsp;&nbsp;&nbsp;&nbsp;Syntax, or the laws and rules that govern whether or not code will work on a computer are very strict.  You must follow syntax rules exactly, or the code will not work.  Some basic things to become aware of are <tt>white space</tt>(spaces, tabs, and newlines) <tt>semicolons</tt>(;), <tt>brackets</tt>(<tt>(),{},[]</tt>), and <tt>comments</tt>(//,/*).  Understanding how these things are used and what they do is fundamental in both writing and reading code.</p>
  
  <p class="rp">&nbsp;&nbsp;&nbsp;&nbsp;<tt>Comments</tt> are denoted on a single line by // or contained within /* Text Here! */.  <tt>Comments</tt> are used to leave notes to yourself about the code or to explain the functionality and thought process you intended for the code so that others can read and understand your program.</p>
  
  <div class="pseudo">//If you make a script with nothing but comments, the computer won\'t find anything to do!</div>
  
  <p class="rp">&nbsp;&nbsp;&nbsp;&nbsp;<tt>Spacing</tt> is what helps make code more readable, and though not always a convention that is necessary for code to run, code is already hard enough to read as it is.  Each line is typically used for a single command - when you start writing a new command you go to a new line, this also allows error reporting programs, or "<tt>debuggers</tt>", to help you pinpoint your problem because they can tell you exactly what line the error is occurring on.</p>
  
  <div class="pseudo">Get bread\nGet peanutButter\nSpread peanutButter\nAssemble sandwich\nDevour sandwich</div>
  
  <p class="rp">&nbsp;&nbsp;&nbsp;&nbsp;<tt>Tabs</tt> are used to create what is called <tt>indentation</tt>, which is very important when reading code.  Programming instructions are arranged in a hierarchy - that is, some instructions of code may have certain pieces of memory (variables), or other instructions that they have control of.  This is a form of <tt>Parent</tt> and <tt>Child</tt> relationship, a concept that will come up many times in programming in different ways.  In this context, the <tt>child</tt> code will be directly underneath its <tt>parent</tt> code and <tt>indented</tt> with one more tab then the <tt>parent</tt> code is.</p>
  
  <div class="pseudo">MakePeanutButterSandwich\n\tGet bread\n\tGet peanutButter\n\tSpread peanutButter\n\tAssemble sandwich\n\tDevour sandwich</div>
  
  <p class="rp">&nbsp;&nbsp;&nbsp;&nbsp;<tt>Semicolons</tt> are a very common feature in many languages, and like newlines denote the end of a command, or rather, separate one command from another.  Unlike newlines, however, <tt>semicolons</tt> are not optional.  With the exception of <tt>if</tt>, <tt>for</tt>, and <tt>while</tt> statements - which don\'t need <tt>semicolons</tt> and are covered later - if you are missing a single <tt>semicolon</tt> somewhere in your code the whole thing won\'t work.  Chances are the only way to find the error will be to read through the whole thing looking for that one insignificant missing character, so its best to make <tt>semicolons</tt> an ingrained habit.</p>
  
  <div class="pseudo">MakePeanutButterSandwich\n\tGet bread;\n\tGet peanutButter;\n\tSpread peanutButter;\n\tAssemble sandwich;\n\tDevour sandwich;</div>
  
  <p class="rp">&nbsp;&nbsp;&nbsp;&nbsp;Brackets perform a role similar to <tt>indentation</tt>.  They are used to create a hierarchy of <tt>parent</tt> and <tt>child</tt> relationships by grouping children inside of them that are of the same level in the hierarchy, also called <tt>siblings</tt>, and tying them to a <tt>parent</tt>.  Like <tt>semicolons</tt> they are also mandatory, if not implemented in the correct manner and place, your code will break.</p>
  
  <p class="rp">&nbsp;&nbsp;&nbsp;&nbsp;<tt>Parenthetical brackets</tt> - () - are used for function parameter grouping, which we\'ll talk about more in depth later, and for order of operations when you perform math on things.  <tt>Squiggly brackets</tt> - {} - are used in conjunction with tabs and newlines to group lines of code under their parent code lines.  <tt>Square brackets</tt> - [] - are used specifically for a special kind of memory grouping called an <tt>Array</tt>, which will be covered in detail later.</p>

  <div class="pseudo">MakeSandwich(peanutButter) {\n\tGet(bread);\n\tGet(peanutButter);\n\tSpread(peanutButter);\n\tAssemble(sandwich);\n\tDevour(sandwich);\n}</div>

  <h2>Stored Information - Variables</h2>
  <p class="rp">&nbsp;&nbsp;&nbsp;&nbsp;Computers only do exactly what they are told, and know only exactly what they are given at any point in time.  <tt>Variables</tt> are a vital tool that allow us to handle data and information: manipulating it, moving it around, and ensuring that the data is in the correct form and place at the correct time.  A <tt>variable</tt> is a virtual object that stores data, whether that data be a number, a string of characters, or a <tt>reference</tt> (in a sense, a pointer) to another <tt>variable</tt>.</p>

    <div class="ex">int num = 4;\nprint(num);</div>



  <p class="rp">&nbsp;&nbsp;&nbsp;&nbsp;<tt>Variables</tt> in Java are typed, that is, when created the <tt>variable</tt> will only be able to contain a specific kind of information.  A <tt>variable</tt> initialized to hold numbers will not hold words for instance.  To this end, there are many different types of <tt>variables</tt>, ones that can hold numbers of varying sizes and decimal place accuracies such as <tt>int</tt>, <tt>double</tt>, and <tt>long</tt>.  There are types that will hold single characters, such as <tt>char</tt>, and a special type of variable called a <tt>string</tt> that points to words and sentences by building on top of the basic <tt>variable</tt> functionalities.  <tt>Boolean</tt> variable types hold either true or false and nothing else - simplistic, yet very useful and efficient.</p>

    <div class="ex">String out = "Hello World";\nprint(out);</div>

  <p class="rp">&nbsp;&nbsp;&nbsp;&nbsp;There are many different types of variables that can be initialized. In fact, you can even create your own variable and class types. Variables can also be reassigned to hold different information. Modifying the values of variables is also important and useful.</p>

    <div class="ex">int num = 4;\nnum = 3;\nprint(num);num = num+3;\nprint(num);String out = "Hello World";\nprint(out);out = out + " again";\nprint(out);</div>

  <p class="rp">&nbsp;&nbsp;&nbsp;&nbsp;<tt>Reference variables</tt>, more commonly called <tt>pointers</tt>, are <tt>variables</tt> that hold the location of constructs of information such as other <tt>variables</tt>, groups of <tt>variables</tt>, and many other things.  While chaining their use can become confusing, developing the skills and understanding of how they function will be very helpful.  <tt>Pointers</tt> are an integral part of programming.</p>

    <div class="ex">int[] numArray;\nnumArray = new int[3];\nnumArray[0] = 1;\nnumArray[1] = 2;\nnumArray[2] = 3;\nprint(numArray[1]);</div>

  <h2>Expressions</h2>
  <p class="rp">&nbsp;&nbsp;&nbsp;&nbsp;A considerable amount of your time programming will be spent devising ways to extrapolate the important information held in the data, this is often done by writing what is called an <tt>expression</tt>.  An <tt>expression</tt> takes several inputs - a combination of <tt>variables</tt> and <tt>constants</tt> - and produces a single output.  Math, <tt>string</tt> manipulation, and <tt>boolean</tt> logic are all forms of <tt>expressions</tt>.  For those unfamiliar with the term, <tt>boolean</tt> logic is a sort of math performed on true and false, instead of numbers.</p>

  <p class="rp">&nbsp;&nbsp;&nbsp;&nbsp;<tt>Operators</tt> are functions that usually take two inputs and produce one output, and are used to evaluate <tt>expressions</tt>, to find out what they simplify to.  The +,-,*,/,%,^ signs are all mathematical <tt>operators</tt>, more formally called the <tt>Arithmetic Operators</tt>.  For those unfamiliar with the % operator, it is called <tt>modulus</tt>, or \'remainder after division\'.  <tt>Modulus</tt> makes numbers act as if on a clock, they wrap around after a certain magnitude.  For example, if you wait 13 hours from noon, it will be 1 o\'clock.</p>

  <div class="ex">print((13*1)%(6+6));</div>

  <p class="rp">&nbsp;&nbsp;&nbsp;&nbsp;<tt>Relational operators</tt> make a statement about equality between two operands, and then evaluate to either true or false.  These are the ==(equals), !=(not equals), &gt;(greater than), &lt;(less than), &lt;=(less than or equals), and &gt;=(greater than or equals) operators.  Take careful note that the == <tt>operator</tt> and =, the <tt>assignment operator</tt>, are completely different.  The = <tt>operator</tt> will assign one value to another, usually variables, while the == <tt>operator</tt> checks to see if the two operands are equivalent.</p>

  <div class="ex">print((1+1)==5);</div>

  <p class="rp">&nbsp;&nbsp;&nbsp;&nbsp;<tt>Logical operators</tt> perform what is called <tt>boolean logic</tt>, and concern whether a statement is true or false.  These operators include the &&(and),||(or), and !(not, one of the few operators to take only a single input expression).  These are primarily used to direct <tt>conditional logic</tt>, the focus of the next subject.</p>

  <div class="ex">print(true && false);</div>

  <h2>Controlling Logic Flow - Conditionals</h2>
  <p class="rp">&nbsp;&nbsp;&nbsp;&nbsp;Crucial to useful programs is our ability to give computers the ability to make choices based on the information that they are given.  This is done through <tt>conditionals</tt>, also called control statements, such as <tt>if</tt>, <tt>while</tt>, and <tt>for</tt>.</p>

  <p class="rp">&nbsp;&nbsp;&nbsp;&nbsp;<tt>If</tt> statements are the most elementary of <tt>conditionals</tt>.  The <tt>if</tt> statement is given control of some of its own instructions, indicated by some conventions discussed earlier (tabs, {} braces).  The <tt>if</tt> statement will check its condition, which ultimately evaluates to true or false.  If the statement is true, the <tt>if</tt> statements own set of instructions will be executed, otherwise they will be passed over.</p>

  <div class="ex">if( 1+1 == 2 ) {\n\tprint("Yes! one plus one is two");\n}\nif( 1 + 1 == 3) {\n\tprint("I will not be printed :-(");\n}</div>
  
  <p class="rp">&nbsp;&nbsp;&nbsp;&nbsp;<tt>If</tt> statements can be further extended in influence and ability using the <tt>else</tt> statement.  Appended to an <tt>if</tt> statement, the <tt>else</tt> statement denotes instructions to be run if its partner <tt>if</tt> statement resolves to false.  The <tt>else</tt> statement can even branch to more <tt>if</tt> and <tt>else</tt> statements to create a nested tree of logic to accommodate the programs purpose.</p>

  <div class="ex">if (3==8) {\n\tprint("this won\'t print");\n} else {\n\tprint("but this will");\n}</div>

  <p class="rp">&nbsp;&nbsp;&nbsp;&nbsp;<tt>For loops</tt> perform their commands a certain number of times.  They are traditionally given a variable which they increment each loop until the given condition is met, and the loop terminates.</p>

  <div class="ex">for(int i=1; i<4; i++) {\n\tprint("This is loop #:" + i);\n}</div>

  <p class="rp">&nbsp;&nbsp;&nbsp;&nbsp;<tt>While loops</tt> come in two forms, <tt>do while</tt> and <tt>while</tt>.  <tt>Do while</tt> will loop once no matter what, since it checks its condition after running.  <tt>While</tt> will check its condition before running, and may therefore not run at all depending on the rest of the code.

  <div class="ex">int num = 0;\nwhile(num < 3) {\n\tprint(num);\n\tnum = num + 1;\n}</div>
  '

  examples = $(ref).children(".ex")

  $(refContainer).prepend(ref)

  closeClick = () ->
    $(backFade).remove()
    $(refContainer).remove()
    codeland.doppioAPI.abort()

  $("#bF").click(closeClick)

  for sel in [0...examples.size()]
    setUpExample(examples.eq(sel))



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

    backFade = document.createElement("div")
    refContainer = document.createElement("div")

    $(backFade).css({width:'100%',height:'100%',position:'absolute','z-index':'300','background-color':'#000000','opacity':'.5'})
    $(refContainer).css({ width:'60%',height:'60%',left:'30%',top:'30%',position:'absolute','z-index':'301','background-color':'#FFFFFF'})

    $("body").prepend(backFade)
    $(backFade).attr({id:'bF'})
    $("body").prepend(refContainer)

    header = document.createElement("div")
    para = document.createElement("div")

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
    Original software created by University of Illinois students and faculty, Chris Liu, Fabian Junge, James Kelly and Lawrence Angrave.<br>Additional Development done by Bharat Ponnaluri,Yi Gao, Julia Syi, Lavanya Iyer, and Noyan Baykal
    <br/>
    "

  $(refContainer).append(header)
  $(refContainer).append(para)
  $("#bF").click(closeClick)