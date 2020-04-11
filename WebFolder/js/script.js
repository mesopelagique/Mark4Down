window.onload = function() {
    var postChange = function(value) {
        var xhttp = new XMLHttpRequest();
        xhttp.open("POST", window.location, true);
        xhttp.setRequestHeader("Content-type", "text/markdown");
        xhttp.send(value);
    };
    var saveData = (function () {
        var a = document.createElement("a");
        document.body.appendChild(a);
        a.style = "display: none";
        return function (text, fileName) {
            var blob = new Blob([text], {type: "octet/stream"}),
                url = window.URL.createObjectURL(blob);
            a.href = url;
            a.download = fileName;
            a.click();
            window.URL.revokeObjectURL(url);
        };
    }());

    // trick to prepare toolbar
    var simplemde = new SimpleMDE({
	    showIcons: ["code", "table", "heading-2", "heading-3","clean-block", "horizontal-rule", "undo", "redo"],
    });
 
    simplemde.toolbar.push("|");
	simplemde.toolbar.push(
        {
			name: "download",
			action: function customFunction(){
                console.log("download")
                var content = simplemde.value();
                var currentPage = window.location.href;
                var fileName = currentPage.substring(currentPage.lastIndexOf('/') + 1);
                saveData(content, fileName);

			},
			className: "fa fa-download",
			title: "download",
			id: "download-button"
		}
    );
    simplemde.toolbar.push(
        {
			name: "diff",
			action: function customFunction(){
                var fileName = window.location.pathname;
                if (fileName == "/") {
                    fileName="/README.md"
                }
               // window.open('/mark4down/diff'+fileName, '_blank');

                var previewPanel = document.getElementsByClassName("editor-preview-side")[0];
                previewPanel.classList.add("editor-preview-active-side");
                previewPanel.innerHTML='<object type="text/html" style="width: 100%; height: 100%" data="/mark4down/diff'+fileName+'" ></object>';
		
			},
			className: "fas fa-exchange-alt",
			title: "diff",
			id: "diff-button"
		}
    );
    simplemde.toolbar.push("|");
    simplemde.toolbar.push(
        {
			name: "list",
			action: function customFunction(){
                console.log("go to list");
                // window.location = "/mark4down/list";
                var previewPanel = document.getElementsByClassName("editor-preview-side")[0];
                previewPanel.classList.add("editor-preview-active-side");
                previewPanel.innerHTML='<object type="text/html" style="width: 100%; height: 100%" data="/mark4down/list" ></object>';
			},
			className: "fa fa-list",
			title: "list",
			id: "list-button"
		}
    );
    simplemde.toolbar.push(
        {
			name: "missing",
			action: function customFunction(){
                console.log("go to missing");
                // window.location = "/mark4down/missing";
                var previewPanel = document.getElementsByClassName("editor-preview-side")[0];
                previewPanel.classList.add("editor-preview-active-side");
                previewPanel.innerHTML='<object type="text/html" style="width: 100%; height: 100%" data="/mark4down/missing" ></object>';
			},
			className: "fas fa-book-dead",
			title: "missing",
			id: "missing-button"
		}
    );
    simplemde.toolbar.push(
        {
			name: "github",
			action: function customFunction(){
                window.open('/mark4down/github', '_blank');
			},
			className: "fa fa-github",
			title: "github",
			id: "github-button"
		}
    );
    simplemde.toolbar.push(
        {
			name: "fulldiff",
			action: function customFunction(){
                window.open('/mark4down/diff/', '_blank');
			},
			className: "fab fa-stack-exchange",
			title: "fulldiff",
			id: "fulldiff-button"
		}
    );

	var tools = simplemde.toolbar;
	simplemde.toTextArea();
	simplemde = null;

    // Init the real mde
    var simplemde = new SimpleMDE({
        renderingConfig: {codeSyntaxHighlighting: true},
        element: document.getElementById('pad'),
        placeholder: "Type here...",
        previewRender: function(plainText, preview) { // Async method
            setTimeout(function(){
                postChange(plainText);
                document.querySelectorAll('pre code').forEach((block) => {
                    hljs.highlightBlock(block);
                });
            }, 0);
            return simplemde.markdown(plainText);
        },
		toolbar: tools,
    });
    simplemde.toggleSideBySide();
    hljs.initHighlightingOnLoad();
};
