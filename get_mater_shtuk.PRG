* �������� ��� ������� ���������� ������������� � ������
* parkod - ��������
* parkol - ���������� ��������� � ��� ��������
lparameters parkodm,parkol 
local res,hh,rr

res = ''

hh = sqlconnect('sqldb','sa','111')
if hh > 0
	rr = sqlexec(hh,'select * from mater where kodm = ?parkodm','cdmater')
	if rr = -1
		eodbc('get_mater_shtuk sele')
	endif	
	select cdmater
	if reccount()>0
		if cdmater.ei <> cdmater.ei1
			if alltrim(cdmater.ei) == '��.' and cdmater.v1000 <> 0 
				res = str(parkol/(cdmater.v1000/1000)) + ' ��.'
			endif
		endif
	endif
	sqldisconnect(hh)
else
	eodbc('get_mater_shtuk conn')
endif

return res

