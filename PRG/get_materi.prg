lparameters parKodm
local mres
mres =''

* быстро получить наименование материала
if parKodm<>0
	mres = arMat[parKodm]
endif

return mres
