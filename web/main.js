
$(document).ready(function(){
    $.ajax({
        url: '../files.txt',
        dataType:"text",
        async:"false",
        success:function(data){
            var files=data.split("\n")
            for(var i=0;i<files.length;i++){

                if(files[i].indexOf("/ace/")==-1){
                    if(files[i].indexOf("setup")==-1){
                        if(files[i].length!=0){
                            console.log("Loading file:"+files[i])
                            console.log(files[i].length)
                            var s = document.createElement("script");
                            s.type = "text/javascript";
                            s.src = "../"+files[i]
                            // Use any selector
                            $("head").append("")
                            document.getElementsByTagName("head")[0].appendChild(s);                         console.log(s)
                        }

                    }

                }

            }
        }
    })

    $("html").css({height:'100%',width:'100%','margin':'0','padding':'0','overflow':'hidden'})

    //Load the JavaScript files

    //http://colorschemedesigner.com/#3La1Yw0w0w0w0

    window.addEventListener('resize', function(){
        if ((window.orientation === 90) || (window.orientation === -90))
            $('#title').css({height:"15%"})
        else
            $('#title').css({height:"20%"})
    }, false)

    window.initialize($('#UI')[0])
});
