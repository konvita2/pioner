* ������� ������ � ���� "������ 2007 �."
lparameters parGod,parMes
local smes
local res

res = ''

do	case
	case	parMes = 1
		smes = '������'
	case	parMes = 2
		smes = '�������'
	case	parMes = 3
		smes = '����'
	case	parMes = 4
		smes = '������'
	case	parMes = 5
		smes = '���'
	case	parMes = 6
		smes = '����'
	case	parMes = 7
		smes = '����'
	case	parMes = 8
		smes = '������'
	case	parMes = 9
		smes = '��������'
	case	parMes = 10
		smes = '�������'
	case	parMes = 11
		smes = '������'
	case	parMes = 12
		smes = '�������'
	otherwise
		smes = ''
endcase  

res = smes + ' ' + alltrim(str(parGod)) + ' �.'

return res