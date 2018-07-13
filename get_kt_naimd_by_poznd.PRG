lparameters parPoznd
local mres
mres = ''

select naimd from kt where !empty(naimd) and !empty(poznd) and alltrim(poznd) == alltrim(parPoznd) and d_u < 5 into cursor c700
if reccount()>0
	mres = alltrim(c700.naimd)
endif
use in c700

return mres