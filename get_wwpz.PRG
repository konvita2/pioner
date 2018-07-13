* получить № план-задания по № ЛЗК
lparameters parNom
local res 
res = 0

local hh,rr
hh = sqlconnect('sqldb','sa','111')
if hh > 0
	rr = sqlexec(hh,'')

	sqldisconnect(hh)
else
	eodbc('get_wwpz conn')
endif




select * from wwlim where nom = parNom into cursor c881
if reccount()>0
	select * from wwpz where nomlim = c881.id into cursor c501
	if reccount()>0
		res = c501.nompz
	endif
	use in c501
endif
use in c881

return res