* �������� ���������� �� �������� �� ��� ��������������
lparameters parDogId
local di,res

res = ''
di = parDogId

select * from dog,post where dog.post = post.id and dog.id = di into cursor cc900
if reccount()>0
	res = '���.�' + alltrim(cc900.ndog) + ' �� ' + dtoc(cc900.dat) + ;
		alltrim(cc900.naim) + '(' + alltrim(cc900.adr) + ')'
endif
use in cc900

return res
