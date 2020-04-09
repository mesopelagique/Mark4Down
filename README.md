# Mark4Down

Realtime markdown editor example in your database.

Edit documentation from your local machine or remote device such as iPad. The file is saved automatically. New file too.

## Usage

### Using your database web server

In `On Web Connection` method, if you want to edit file into root database folder simply do

```4d
$markdown:=mark4down (Folder(fk database folder) ;$1;$2)

If (Not($markdown))
	// deliver others files, like image if not managed by mark4down
	// you can limit to images or folder Documentation, as you want;
	// or do other requests on your server
	WEB SEND FILE($rootFolder.file(Substring($1;2)).platformPath)
End if
```

with `$1`, the file name and `$2` the http method (`GET` or `POST`) , ie. parameters of  `On Web Connection`

Then open your browser to see it live

---

![preview](Documentation/preview.png)

---

### Using the component web server

#### by accepting to execute `On Host Database Event` method of the component

_In database setting, security tab..._

A web server for the component will be started when your database start.

Its configuration is defined by component in [settings.4DSettings](Project/Sources/settings.4DSettings), so the url will be 
http://localhost:8349

#### or by starting the component web server yourself

```4d
mark4downWebServer().start() //  you can choose options like HTTP port
```

## More

### Add your own style

Go to `WebFolder` and add it to `style.css` file or add a link to a css file into `editor.md.html`

## Acknowledgment

- Markdown editor by [SimpleMDE](https://github.com/sparksuite/simplemde-markdown-editor)
- Code syntax highlighting by [highlightjs](https://highlightjs.org/) with [4d addon](https://github.com/highlightjs/highlightjs-4d)
