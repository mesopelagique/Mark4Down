
$rootFolder:=Folder:C1567(fk database folder:K87:14)
$markdown:=mark4 ($rootFolder;$1;$2)
If (Not:C34($markdown))  // deliver others files, like image if not managed by mark4
	WEB SEND FILE:C619($rootFolder.file(Substring:C12($1;2)).platformPath)
End if 
