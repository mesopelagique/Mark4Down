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
C_TEXT:C284($text;$output;$relativePath;$emoji)
$file:=$root.file($name)

Case of 
	: ($file.extension=".md")
		
		Case of 
			: (Position:C15("GET";$method)=1)
				
				If (Not:C34($file.exists))
					$text:="# "+$file.name+"\n\nWrite your text here..."
					$file.create()
					$file.setText($text)
				Else 
					$text:=$file.getText(106;Document with LF:K24:22)
				End if 
				
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
		
	: (Position:C15("mark4down/";$name)=1)
		
		$name:=Replace string:C233($name;"mark4down/";"")
		
		Case of 
			: ($name="list")
				$text:=""
				For each ($file;$root.files(fk recursive:K87:7).sort("path"))
					If ($file.extension=".md")
						$relativePath:=Replace string:C233($file.path;$root.path;"")
						
						Case of 
							: (Position:C15("LICENSE";Uppercase:C13($file.name))>0)
								$emoji:="⚖️"
							: (Position:C15("Documentation";$relativePath)>0)
								$emoji:="📚"
							Else 
								$emoji:="📝"
						End case 
						
						$text:=$text+"<a href=\"/"+$relativePath+"\">"+$emoji+" "+$relativePath+"</a><br/>"
					End if 
				End for each 
				
				$output:=Folder:C1567(fk resources folder:K87:11).file("list.md.html").getText()
				$output:=Replace string:C233($output;"{{lists}}";$text)
				$output:=Replace string:C233($output;"{{title}}";"")
				WEB SEND TEXT:C677($output)
				
			: ($name="missing")
				$text:=""
				For each ($file;$root.folder("Project/Sources/Methods").files(fk recursive:K87:7).sort("path"))
					If (($file.extension=".4dm") & (Position:C15("Compiler_";$file.name)#1)
						
						If (Not:C34($root.folder("Documentation/Methods").file($file.name+".md").exists))
							
							$relativePath:=Replace string:C233($root.folder("Documentation/Methods").file($file.name+".md").path;$root.path;"")
							$emoji:="⭕"
							$text:=$text+"<a href=\"/"+$relativePath+"\">"+$emoji+" "+$relativePath+"</a><br/>"
						End if 
					End if 
				End for each 
				
				$output:=Folder:C1567(fk resources folder:K87:11).file("list.md.html").getText()
				$output:=Replace string:C233($output;"{{lists}}";$text)
				$output:=Replace string:C233($output;"{{title}}";"Missing")
				WEB SEND TEXT:C677($output)
				
			: ($name="github")
				
				C_TEXT:C284($in;$out)
				SET ENVIRONMENT VARIABLE:C812("_4D_OPTION_CURRENT_DIRECTORY";$root.platformPath)
				LAUNCH EXTERNAL PROCESS:C811("git remote -v";$in;$out)
				
				For each ($text;Split string:C1554($out;"\n")) Until (Length:C16($in)>0)
					If (Position:C15("github.com";$text)>1)
						$text:=Substring:C12($text;Position:C15("http";$text))
						$in:=Substring:C12($text;1;Position:C15(" ";$text)-1)
					End if 
				End for each 
				
				If (Length:C16($in)>0)
					WEB SEND HTTP REDIRECT:C659($in)
				End if 
				
			Else 
				
		End case 
		$0:=True:C214
		
	Else 
		
		$0:=False:C215
		
End case 

