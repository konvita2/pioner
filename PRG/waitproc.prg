* ������������ ��� ������ ��������� � ���������� �������
* ������ �������������� 2 ����-� ����������
*	glLastProc
*	glLastTime
lparameters parRecno,parReccount,parStr

local nnn

nnn = int(100*parRecno/parReccount)

if nnn <> glLastProc
	local ttm,vrem,vrems
	ttm = seconds()
	
	vrem = (100 - nnn) * (ttm - glLastTime)
	
	if vrem > 60
		vrems = alltrim(str(int(vrem/60))) + ' ���.'
	else
		vrems = alltrim(str(vrem)) + ' ���.'
	endif

	wait window nowait parStr + ' ' + alltrim(str(nnn)) + '% (���. ' + vrems + ')'  
	glLastProc = nnn
	glLastTime = seconds()
endif

return



