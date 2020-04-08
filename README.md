# Mark4Down

Realtime markdown editor example in your database.

## Usage

In `On Web Connection` method, if you want to edit file into root database folder simply do

```4d
$rootFolder:=Folder(fk database folder) // folder to edit files

$markdown:=mark4 ($rootFolder;$1;$2)

If (Not($markdown))
	// deliver others files, like image if not managed by mark4
	// you can limit to images or folder Documentation, as you want;
	// or do other request on your server
	WEB SEND FILE($rootFolder.file(Substring($1;2)).platformPath)
End if
```

with `$1`, the file name and `$2` the http method (`GET` or `POST`)

Then open your browser to see it live

---

![preview](Documentation/preview.png)

---

Edit documentation from your local machine or remote device such as iPad. The file is save automatically. New file too.

### Add your own style

Go to `WebFolder` and add it to `style.css` file or add a link to a css file into `editor.md.html`

## Acknowledgment

- Markdown editor by [SimpleMDE](https://github.com/sparksuite/simplemde-markdown-editor)
- Code syntax highlighting by [highlightjs](https://highlightjs.org/) with [4d addon](https://github.com/highlightjs/highlightjs-4d)
