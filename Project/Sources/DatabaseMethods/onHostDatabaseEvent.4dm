C_LONGINT($1)
Case of 
    : ($1=On before host database startup)
          
    : ($1=On after host database startup)
        
        webServer:=WEB Server()
        webServer.start()
        
    : ($1=On before host database exit)
        
        webServer.stop()
        
    : ($1=On after host database exit)
         
 End case