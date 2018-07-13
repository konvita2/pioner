* получить наименование оборудования по инв. №
lparameters parInvn
local mres

select * from obor where alltrim(invn) == alltrim(parInvn) ;
	into cursor cobo1
if reccount()>0
	mres = cobo1.naim
else
	mres = ''
endif	
use in cobo1

return mres	 