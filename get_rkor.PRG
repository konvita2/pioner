* �������� ������� ����� ����
* �.�. �� 13.2 ���������� 13
* pars
lparameters pars
local res,pos
res = ''

pars = alltrim(pars)
pos = at('.',pars)
res = substr(pars,1,pos-1)

return res
