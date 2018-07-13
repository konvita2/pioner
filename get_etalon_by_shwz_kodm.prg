* получить количество материала по шифру запуска
lparameters parShwz,parKodm
local res

select * from v_shwzras;
	where ;
		!empty(shwz) and ;
		alltrim(shwz) == alltrim(parShwz) and;
		kodm = parKodm ;
	into cursor cc120
if reccount()>0
	res = cc120.kolzap
else
	res = 0
endif
use in cc120

return res		