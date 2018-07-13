lparameters parId
local mres
mres = 0

select cena from ostatok where id = parId into cursor cc90
if reccount()>0
	mres = cc90.cena
endif
use in cc90

return mres