* получить примечание по poznd
lparameters parPoznd
local mpp,mres,mfound 

mpp = parPoznd
mres=''
mfound = .f.

select top 1 * from cktshwz where poznd=?parpoznd and d_u<4 order by poznd into cursor ckti

select ckti
if reccount()>0
	local f1,f2,f3,f4,f5
	f1 = iif(empty(ckti.primech), '',alltrim(ckti.primech)+'; ')	
	f2 = iif(empty(ckti.kodzagim), '',alltrim(ckti.kodzagim)+'; ')	
	f3 = iif(empty(ckti.pokr),'',alltrim(ckti.pokr)+'; ')
	f4 = iif(empty(ckti.gpokr),'',alltrim(ckti.gpokr)+'; ')
	f5 = iif(empty(ckti.twer),'',alltrim(ckti.twer))
	mres = f1 + f2 + f3 + f4 + f5	
endif

use in ckti

return mres

