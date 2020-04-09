//%attributes = {"shared":true,"preemptive":"capable"}
C_BOOLEAN:C305($0)

C_OBJECT:C1216($1;$root)
$root:=$1
ASSERT:C1129(OB Class:C1730($1).name="Folder")

C_TEXT:C284($2;$name)
$name:=$2
If (Position:C15("/";$name)=1)
	$name:=Substring:C12($name;2)
End if 
If (Length:C16($name)=0)
	$name:="README.md"
End if 
C_TEXT:C284($3;$method)
$method:=$3

C_OBJECT:C1216($file)
C_TEXT:C284($text)
$file:=$root.file($name)

If ($file.extension=".md")
	
	Case of 
		: (Position:C15("GET";$method)=1)
			
			If (Not:C34($file.exists))
				$text:="# "+$file.name+"\n\nWrite your text here..."
				$file.create()
				$file.setText($text)
			Else 
				$text:=$file.getText(106;Document with LF:K24:22)
			End if 
			
			C_TEXT:C284($output)
			$output:=Folder:C1567(fk resources folder:K87:11).file("editor.md.html").getText()
			$output:=Replace string:C233($output;"Write your text here..";$text)
			
			WEB SEND TEXT:C677($output)
			
		: (Position:C15("POST";$method)=1)
			
			If (Not:C34($file.exists))
				$text:="# "+$name+"\n\nWrite your text here..."
				$file.create()
			End if 
			
			$text:=""
			WEB GET HTTP BODY:C814($text)
			$file.setText($text;106;Document with LF:K24:22)
			
			WEB SEND TEXT:C677("ok")
			
		Else 
			
			WEB SEND TEXT:C677("Unknown method")
			
	End case 
	
	$0:=True:C214
	
Else 
	
	$0:=False:C215
	
End if 

