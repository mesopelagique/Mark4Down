# Mark4Down
[![language][code-shield]][code-url]
[![language-top][code-top]][code-url]
![code-size][code-size]
[![release][release-shield]][release-url]
[![license][license-shield]][license-url]

Realtime markdown editor for your 4D database.

Edit documentation from your local machine or remote device such as iPad. The file is saved automatically. New file too.

## Usage

### Using your database web server

In `On Web Connection` method, if you want to edit file into yor root database folder simply do

```4d
$markdown:=mark4down (Folder(fk database folder) ;$1;$2)

If (Not($markdown))
	// deliver others files, like image if not managed by mark4down
	// you can limit to images or folder Documentation, as you want;
	// or do other requests on your server
	WEB SEND FILE($rootFolder.file(Substring($1;2)).platformPath)
End if
```

> with `$1`, the file name and `$2` the http method (`GET` or `POST`) , ie. parameters of  `On Web Connection`

Then open your browser to see the web markdown editor

---

![preview](Documentation/preview.png)

---

### Using the component web server

If do not want to poluate your database web server, a component could provide one since new 18R release.

There is two way to launch the component web server:

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

<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
[code-shield]: https://img.shields.io/static/v1?label=language&message=4d&color=blue
[code-top]: https://img.shields.io/github/languages/top/mesopelagique/Mark4Down.svg
[code-size]: https://img.shields.io/github/languages/code-size/mesopelagique/Mark4Down.svg
[code-url]: https://developer.4d.com/
[release-shield]: https://img.shields.io/github/v/release/mesopelagique/Mark4Down
[release-url]: https://github.com/mesopelagique/Mark4Down/releases/latest
[license-shield]: https://img.shields.io/github/license/mesopelagique/Mark4Down
[license-url]: LICENSE.md
