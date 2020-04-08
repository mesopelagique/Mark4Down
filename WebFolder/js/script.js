window.onload = function() {
    var postChange = function(value) {
        var xhttp = new XMLHttpRequest();
        xhttp.open("POST", window.location, true);
        xhttp.setRequestHeader("Content-type", "text/markdown");
        xhttp.send(value);
    };
    var simplemde = new SimpleMDE({
        renderingConfig: {codeSyntaxHighlighting: true},
        element: document.getElementById('pad'),
	    showIcons: ["code", "table", "horizontal-rule", "undo", "redo"],
        placeholder: "Type here...",
        previewRender: function(plainText, preview) { // Async method
            setTimeout(function(){
                postChange(plainText);
            }, 0);
            return simplemde.markdown(plainText);
        },
    });
    simplemde.toggleSideBySide();
    hljs.initHighlightingOnLoad();
};
