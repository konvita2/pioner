* ������� ��������� ���� � report
* parFile - ��� ����� ������� ���������� �������
* parRasp - /ver/hor/ ������������ ����� ������
lparameters parFile,parRasp

*
if !file(parFile)
	wait window '���� ' + parFile + ' �� ������!'
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
	wait window '���� ' + parFile + ' �� ������� ���������!'
	return
endif
fclose(fh)