* ������� ������������ ������� ������� ����� �������
lparameters pStatus
local res

res = ''

do case
	case pStatus = 0
		res = '���������������'
	case pStatus = 10
		res = '���������'
	case pStatus = 20
		res = '�����'	
	case pStatus = 15
		res = '�������� �����'		
	case pStatus = 30
		res = '�����������'			
endcase

return res
