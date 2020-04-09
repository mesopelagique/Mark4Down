C_LONGINT:C283($1)
Case of 
	: ($1=On before host database startup:K74:3)
		
	: ($1=On after host database startup:K74:4)
		
		webServer:=WEB Server:C1674(Web database server:K73:30)
		webServer.start()
		
	: ($1=On before host database exit:K74:5)
		
		If (webServer#Null:C1517)
			webServer.stop()
		End if 
		
	: ($1=On after host database exit:K74:6)
		
End case 