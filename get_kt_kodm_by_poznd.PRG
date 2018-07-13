lparameters parPoznd
local mres
mres = 0

select kodm from kt;
	where !empty(poznd) and alltrim(poznd) == alltrim(parPoznd);
		and d_u = 1;
	into cursor c800
if reccount()>0
	mres = c800.kodm
endif	
use in c800	

return mres
