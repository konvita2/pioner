* получить только примечание по poznd
lparameters parPoznd
local mpp,mres

mpp = parPoznd
mres=''

select * from kt where d_u<4 and !empty(poznd) and alltrim(poznd) == alltrim(mpp);
	into cursor c12
if reccount()>0
	mres = alltrim(c12.primech)
endif	
use in c12	

return mres