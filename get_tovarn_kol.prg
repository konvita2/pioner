* ������� ��� ��������� ���������� ��������� � �������� ��������
* �-� � ������ ��� �������� ������
*
lparameters parKodm,parKol
local res
res = 0

select * from mater ;
	where kodm = parKodm;
	into cursor ctov
if reccount()>0
	do	case
		case	ctov.uv > 0 .and. ctov.dp > 0 .and. ctov.shp > 0 .and. ctov.ei <> '�2' .and. ctov.ei <> '�2' .and. ctov.ei <> '��.�.'
			res = parKol / (ctov.dp * ctov.shp * ctov.tm * ctov.uv / 1000000)
		case	ctov.ps > 0
			res = parKol / (ctov.ps/1000)
		case	ctov.dm > 0 .and. ctov.uv > 0
			res = parKol / (3.1415 * ctov.uv * ctov.dm^2 / 4000)
*!*			case	ctov.dp > 0 .and. ctov.shp > 0 .and. (ctov.ei = '�2' .or. ctov.ei = '�2' .or. ctov.ei = '��.�.')
*!*				res = parKol / (ctov.shp * ctov.dp / 1000000)
*!*			case	ctov.dp > 0 .and. ctov.ei = '���.�'
*!*				res = parKol / (dp / 1000000)
		otherwise
			wait window nowait '��� ��������� '+alltrim(str(parKodm))+' /�� ������� ��������� �������� �������!/' 
	endcase		
endif	
use in ctov	

return res
