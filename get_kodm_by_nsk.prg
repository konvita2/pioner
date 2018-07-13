lparameters parNsk
local res

select * from ostatok;
	where nsk = parNsk;
	into cursor cc3
if reccount()>0
	res = cc3.kodm
else
	res = 0
endif	
use in cc3	

return res

	
