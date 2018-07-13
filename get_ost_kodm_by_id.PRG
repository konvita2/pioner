lparameters parId
local mres
mres = 0

select kodm from ostatok where id = parId into cursor cc90
if reccount()>0
	mres = cc90.kodm
endif
use in cc90

return mres