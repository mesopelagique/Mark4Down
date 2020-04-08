window.onload = function() {
    var converter = new showdown.Converter();
    var pad = document.getElementById('pad');
    var markdownArea = document.getElementById('markdown');   

    var convertTextAreaToMarkdown = function(){
        var markdownText = pad.value;
        html = converter.makeHtml(markdownText);
        markdownArea.innerHTML = html;
  
        document.querySelectorAll('pre code').forEach((block) => {
            hljs.highlightBlock(block);
        });
    };

    pad.addEventListener('input', convertTextAreaToMarkdown);

    convertTextAreaToMarkdown();
    hljs.initHighlightingOnLoad();
};

var postChange = function(textarea) {
   // alert(textarea.value );

    var xhttp = new XMLHttpRequest();
    xhttp.open("POST", window.location, true);
    xhttp.setRequestHeader("Content-type", "text/markdown");
    xhttp.send(textarea.value);
};