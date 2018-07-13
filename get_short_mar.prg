* получить короткое наименование маршрута - поле SIM
lparameters parKod
local res

select * from db!v_dosp2 ;
	where kod = parKod ;
	into cursor cc10
if reccount()>0
	res = alltrim(cc10.sim)
else
	res = ''
endif
use in cc10

return res