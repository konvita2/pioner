lparameters parKod
local mres

do 	case	
	case	parKod = 1
		mres = '�������� ������������'
	case	parKod = 2
		mres = '��������� ������������'
	case	parKod = 3
		mres = '����������� �����'
	case	parKod = 4
		mres = '��������� �����������'
	otherwise 
		mres = ''
endcase 

return mres