local mask as string,fndel as String, i as integer
*** dimension arFil[]  
local NumOfFiles as Integer 
local array arFil(1000)
  
mask = sys(5)+sys(2003)+'\~*.xml'

NumOfFiles = adir(arFil,mask)

if NumOfFiles = 0
	*** wait window nowait 'No files' 
else
	wait window nowait 'Удаление временных файлов отчетов' 
	
	i = 1
	do while i <= NumOfFiles
		if arFil[i,3] < date() && delete notoday's files
			fndel = sys(5) + sys(2003) + "\" + arFil[i,1]
			wait window nowait 'Удаление врем. файла отчета ' + fndel
			erase (fndel) 	
		endif
		i = i+1
	enddo
		
endif

