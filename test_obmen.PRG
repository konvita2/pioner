* ��������� ���� �� ��������� ��������� ���������� �������� � 
* ���������� ������� ����������
local mtime,mfl,mpredtime

mpredtime = getnastr('obmentime')
mfl = getnastr('ostatpath')
if !empty(mfl)
	mtime = ftime(mfl)
	if alltrim(mpredtime) <> alltrim(mtime)
		local ms
		ms = '����� �������� ��������� �������� ���������� �� ������� ����� ������. �������� ����� ������ �������?'
		if messagebox(ms,4+32,'��������!')=6
			do loadspr_new
		endif	
	endif	
endif