//===================================================
Class constructor
	
	var $1 : Integer
	
	This:C1470.server:=WEB Server:C1674(Web server database:K73:30)
	This:C1470.root:=Folder:C1567(Folder:C1567(fk database folder:K87:14;*).platformPath;fk platform path:K87:2)  //.folder("Project/Sources")  // Unsandboxed for LEP
	This:C1470.resources:=Folder:C1567(fk resources folder:K87:11)
	This:C1470.style:="github.css"
	
	Case of 
			
			//__________________________________
		: (Count parameters:C259=0)
			
			// <NOTHING MORE TO DO>
			
			//__________________________________
		: ($1=On after host database startup:K74:4)
			
			This:C1470.server.start()
			
			//__________________________________
		: ($1=On before host database exit:K74:5)
			
			This:C1470.server.stop()
			
			//__________________________________
	End case 
	
	//===================================================
Function startServer
	
	If (Not:C34(Bool:C1537(This:C1470.server.isRunning)))
		
		This:C1470.server.start()
		
	End if 
	
	//===================================================
Function stopServer
	
	If (Bool:C1537(This:C1470.server.isRunning))
		
		This:C1470.server.stop()
		
	End if 
	
	//===================================================
Function list
	
	This:C1470.startServer()
	OPEN URL:C673("localhost:"+String:C10(This:C1470.server.HTTPPort)+"/mark4down/list")
	
	//===================================================
Function missing
	
	This:C1470.startServer()
	OPEN URL:C673("localhost:"+String:C10(This:C1470.server.HTTPPort)+"/mark4down/missing")
	
	//===================================================
Function send
	
	var $0 : Boolean
	var $1 : Text  // Name
	var $2 : Text  // Method
	
	var $t;$tRelativePath;$tEmoji;$tOutput;$in;$out : Text
	
	If (Position:C15("/mark4down/";$1)=1)  // Special commands
		
		$0:=True:C214
		
		$1:=Replace string:C233($1;"/mark4down/";"")
		
		$t:=""
		
		Case of 
				
				//……………………………………………………………………………………………………………………………
			: ($1="list")  // List of markdown files
				
				For each ($file;This:C1470.root.files(fk recursive:K87:7).query("extension=:1";".md").sort("path"))
					
					If ($file.extension=".md")
						
						$tRelativePath:=Replace string:C233($file.path;This:C1470.root.path;"")
						
						Case of 
								
								//________________________________________
							: (Position:C15("LICENSE";Uppercase:C13($file.name))>0)
								
								$tEmoji:="⚖️"
								
								//________________________________________
							: (Position:C15("Documentation";$tRelativePath)>0)
								
								$tEmoji:="📚"
								
								//________________________________________
							Else 
								
								$tEmoji:="📝"
								
								//________________________________________
						End case 
						
						$t:=$t+"<a href=\"/"+$tRelativePath+"\">"+$tEmoji+" "+$tRelativePath+"</a><br/>"
						
					End if 
				End for each 
				
				PROCESS 4D TAGS:C816(This:C1470.resources.file("list.html").getText();$t;"";$t)
				WEB SEND TEXT:C677($t)
				
				//……………………………………………………………………………………………………………………………
			: ($1="missing")  // List of missing markdown files
				
				var $bFirst : Boolean
				var $tType : Text
				
				$bFirst:=True:C214
				
				For each ($tType;New collection:C1472("Methods";"Classes"))
					
					For each ($file;This:C1470.root.folder("Project/Sources/"+$tType).files(fk recursive:K87:7).query("extension=:1 AND name != :2";".4dm";"Compiler_@").sort("path"))
						
						If (Not:C34(This:C1470.root.folder("Documentation/"+$tType).file($file.name+".md").exists))
							
							If ($bFirst)
								
								$t:=$t+"<h2>Missing (undocumented code)</h2><br/>"
								$bFirst:=False:C215
								
							End if 
							
							$tRelativePath:=Replace string:C233(This:C1470.root.folder("Documentation/"+$tType).file($file.name+".md").path;This:C1470.root.path;"")
							$tEmoji:="⭕"
							$t:=$t+"<a href=\"/"+$tRelativePath+"\">"+$tEmoji+" "+$tRelativePath+"</a><br/>"
							
						End if 
					End for each 
				End for each 
				
				// TODO orphan (ie. doc without code)
				$bFirst:=True:C214
				
				For each ($tType;New collection:C1472("Methods";"Classes"))
					
					For each ($file;This:C1470.root.folder("Documentation/"+$tType).files(fk recursive:K87:7).sort("path"))
						
						If ($file.extension=".md")
							
							If (Not:C34(This:C1470.root.folder("Project/Sources/"+$tType).file($file.name+".4dm").exists))
								
								If ($bFirst)
									
									$t:=$t+"<h2>Orphan (no code)</h2><br/>"
									$bFirst:=False:C215
									
								End if 
								
								$tRelativePath:=Replace string:C233(This:C1470.root.folder("Project/Sources/"+$tType).file($file.name+".md").path;This:C1470.root.path;"")
								$tEmoji:="🚮"
								$t:=$t+$tEmoji+" "+$tRelativePath+"<br/>"
								
							End if 
						End if 
					End for each 
				End for each 
				
				If (Length:C16($t)=0)
					
					$t:="👍 No missing documentation"
					
				End if 
				
				PROCESS 4D TAGS:C816(This:C1470.resources.file("list.html").getText();$t;"Check files";$t)
				WEB SEND TEXT:C677($t)
				
				//……………………………………………………………………………………………………………………………
			: (Position:C15("diff/";$1)=1)
				
				$1:=Substring:C12($1;Length:C16("diff/")+1)
				
				If (Length:C16($1)>0)
					
					$1:="'"+$1+"'"
					
				End if 
				
				SET ENVIRONMENT VARIABLE:C812("_4D_OPTION_HIDE_CONSOLE";"true")
				SET ENVIRONMENT VARIABLE:C812("_4D_OPTION_CURRENT_DIRECTORY";This:C1470.root.platformPath)
				LAUNCH EXTERNAL PROCESS:C811("git diff-files  --no-prefix --patch  "+$1;$in;$out)
				
				PROCESS 4D TAGS:C816(This:C1470.resources.file("diff.html").getText();$t;"Diff";$out)
				WEB SEND TEXT:C677($t)
				
				//……………………………………………………………………………………………………………………………
			: ($1="github")
				
				SET ENVIRONMENT VARIABLE:C812("_4D_OPTION_HIDE_CONSOLE";"true")
				SET ENVIRONMENT VARIABLE:C812("_4D_OPTION_CURRENT_DIRECTORY";This:C1470.root.platformPath)
				LAUNCH EXTERNAL PROCESS:C811("git remote -v";$in;$out)
				
				For each ($t;Split string:C1554($out;"\n")) Until (Length:C16($in)>0)
					
					If (Position:C15("github.com";$t)>1)
						
						$t:=Substring:C12($t;Position:C15("http";$t))
						$in:=Substring:C12($t;1;Position:C15(" ";$t)-1)
						
					End if 
				End for each 
				
				If (Length:C16($in)>0)
					
					WEB SEND HTTP REDIRECT:C659($in)
					
				End if 
				
				//……………………………………………………………………………………………………………………………
			Else 
				
				$0:=False:C215
				
				//……………………………………………………………………………………………………………………………
		End case 
		
	Else 
		
		If ($1#"/")
			
			$1:=Delete string:C232($1;1;1)
			
			var $file : 4D:C1709.File
			$file:=This:C1470.root.file($1)
			
			If ($file#Null:C1517)
				
				If ($file.extension=".md")
					
					$0:=True:C214
					
					Case of 
							
							//…………………………………………………………………………………………………………
						: (Position:C15("GET";$2)=1)  // Load
							
							If (Not:C34($file.exists))
								
								$t:="# ["+$file.parent.name+"] "+$file.name+"\n\nWrite your text here..."
								$file.create()
								$file.setText($t)
								
							Else 
								
								$t:=$file.getText("UTF-8";Document with LF:K24:22)
								
							End if 
							
							$tOutput:=This:C1470.resources.file("editor.html").getText()
							$tOutput:=Replace string:C233($tOutput;"Write your text here..";$t)
							WEB SEND TEXT:C677($tOutput)
							
							
							PROCESS 4D TAGS:C816(This:C1470.resources.file("editor.html").getText();$t;$t;This:C1470.style)
							WEB SEND TEXT:C677($t)
							
							//…………………………………………………………………………………………………………
						: (Position:C15("POST";$2)=1)  // Save
							
							If (Not:C34($file.exists))
								
								$t:="# "+$1+"\n\nWrite your text here..."
								$file.create()
								CLEAR VARIABLE:C89($t)
								
							End if 
							
							WEB GET HTTP BODY:C814($t)
							$file.setText($t;"UTF-8";Document with LF:K24:22)
							
							WEB SEND TEXT:C677("ok")
							
							//________________________________________
						Else 
							
							WEB SEND TEXT:C677("Unknown method")
							
							//________________________________________
					End case 
				End if 
				
				If (Not:C34($0))
					
					WEB SEND FILE:C619(This:C1470.root.file(Substring:C12($1;2)).platformPath)
					
				End if 
			End if 
		End if 
	End if 
	
	//===================================================
Function setStyle
	
	var $1 : Text
	This:C1470.style:=$1
	
	//===================================================