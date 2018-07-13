lparameters parId
local mres
mres = ''

select cena from ostatok where id = parId into cursor cc90
if reccount()>0
	mres = cc90.ei
endif
use in cc90

return mres