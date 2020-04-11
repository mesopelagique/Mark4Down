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
/**
* Special commands
**/
	: (Position:C15("mark4down/";$name)=1)
		
		$name:=Replace string:C233($name;"mark4down/";"")
		
		Case of 
				  // List of markdown files
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
				
				$output:=Folder:C1567(fk resources folder:K87:11).file("list.html").getText()
				$output:=Replace string:C233($output;"{{lists}}";$text)
				$output:=Replace string:C233($output;"{{title}}";"")
				WEB SEND TEXT:C677($output)
				
				  // List of missing markdown files
			: ($name="missing")
				
				C_BOOLEAN:C305($first)
				$text:=""
				C_TEXT:C284($type)
				$first:=True:C214
				For each ($type;New collection:C1472("Methods";"Classes"))
					For each ($file;$root.folder("Project/Sources/"+$type).files(fk recursive:K87:7).sort("path"))
						If (($file.extension=".4dm") & (Position:C15("Compiler_";$file.name)#1))
							
							If (Not:C34($root.folder("Documentation/"+$type).file($file.name+".md").exists))
								If ($first)
									$text:=$text+"<h2>Missing (undocumented code)</h2><br/>"
									$first:=False:C215
								End if 
								$relativePath:=Replace string:C233($root.folder("Documentation/"+$type).file($file.name+".md").path;$root.path;"")
								$emoji:="⭕"
								$text:=$text+"<a href=\"/"+$relativePath+"\">"+$emoji+" "+$relativePath+"</a><br/>"
							End if 
						End if 
					End for each 
				End for each 
				
				  // TODO orphan (ie. doc without code)
				$first:=True:C214
				For each ($type;New collection:C1472("Methods";"Classes"))
					For each ($file;$root.folder("Documentation/"+$type).files(fk recursive:K87:7).sort("path"))
						If ($file.extension=".md")
							
							If (Not:C34($root.folder("Project/Sources/"+$type).file($file.name+".4dm").exists))
								
								If ($first)
									$text:=$text+"<h2>Orphan (no code)</h2><br/>"
									$first:=False:C215
								End if 
								$relativePath:=Replace string:C233($root.folder("Project/Sources/"+$type).file($file.name+".md").path;$root.path;"")
								$emoji:="🚮"
								$text:=$text+$emoji+" "+$relativePath+"<br/>"
							End if 
						End if 
					End for each 
				End for each 
				
				$output:=Folder:C1567(fk resources folder:K87:11).file("list.html").getText()
				$output:=Replace string:C233($output;"{{lists}}";$text)
				$output:=Replace string:C233($output;"{{title}}";"Check files")
				WEB SEND TEXT:C677($output)
				
			: (Position:C15("diff/";$name)=1)
				
				$name:=Substring:C12($name;Length:C16("diff/")+1)
				If (Length:C16($name)>0)
					$name:="'"+$name+"'"
				End if 
				
				C_TEXT:C284($in;$out)
				SET ENVIRONMENT VARIABLE:C812("_4D_OPTION_CURRENT_DIRECTORY";$root.platformPath)
				LAUNCH EXTERNAL PROCESS:C811("git diff-files  --no-prefix --patch  "+$name;$in;$out)
				
				
				$output:=Folder:C1567(fk resources folder:K87:11).file("diff.html").getText()
				$output:=Replace string:C233($output;"{{diff}}";$out)
				$output:=Replace string:C233($output;"{{title}}";"Diff")
				
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
		
/** 
* Edit markdown files
**/
	: ($file.extension=".md")
		
		Case of 
				  // Load
			: (Position:C15("GET";$method)=1)
				
				If (Not:C34($file.exists))
					$text:="# "+$file.name+"\n\nWrite your text here..."
					$file.create()
					$file.setText($text)
				Else 
					$text:=$file.getText("UTF-8";Document with LF:K24:22)
				End if 
				
				$output:=Folder:C1567(fk resources folder:K87:11).file("editor.html").getText()
				$output:=Replace string:C233($output;"Write your text here..";$text)
				
				WEB SEND TEXT:C677($output)
				
				  // Save
			: (Position:C15("POST";$method)=1)
				
				If (Not:C34($file.exists))
					$text:="# "+$name+"\n\nWrite your text here..."
					$file.create()
				End if 
				
				$text:=""
				WEB GET HTTP BODY:C814($text)
				$file.setText($text;"UTF-8";Document with LF:K24:22)
				
				WEB SEND TEXT:C677("ok")
				
			Else 
				
				WEB SEND TEXT:C677("Unknown method")
				
		End case 
		
		$0:=True:C214
		
	Else 
		
		$0:=False:C215
		
End case 

