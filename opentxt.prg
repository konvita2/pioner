* выводит текстовый файл в report
* parFile - имя файла который необходимо вывести
* parRasp - /ver/hor/ расположение листа отчета
lparameters parFile,parRasp

*
if !file(parFile)
	wait window 'Файл ' + parFile + ' не найден!'
	return
endif

*
local fh
fh = fopen(parFile)
if fh <> -1
	* create cursor
	create cursor cout (ss c(250))	
	* iterate by ...
	do while !feof(fh)
		st = fgets(fh)
		insert into cout (ss) values (st)	
	enddo

	if parRasp = 'hor'
		report form r_hor preview  
	else
		report form r_ver preview
	endif

	use in cout	
else
	wait window 'Файл ' + parFile + ' не удалось прочитать!'
	return
endif
fclose(fh)