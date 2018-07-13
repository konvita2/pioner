lparameters par
local res

select * from cc99 where narid = par into cursor cc97
if reccount()>0
	res = 'X'	
else
	res = ' '
endif
use in cc97

return res