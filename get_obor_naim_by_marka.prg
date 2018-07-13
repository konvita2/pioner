* получить наименование оборудования по марке
* (по марке есть неоднозначность тк в obor не одна строка с таким оборудованием)
lparameters parMarka 
local res

res = ''

select naim from obor ;
	where alltrim(marka) == alltrim(parMarka);
	into cursor cc101
if reccount()>0
	res = alltrim(cc101.naim)
endif	
use in cc101	

return res
