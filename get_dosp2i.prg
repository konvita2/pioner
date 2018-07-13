lparameters parKod
local mres
mres =''

* быстро получить наименование подразделения
if parKod<>0
	mres = arPodr[parKod]
endif

return mres
