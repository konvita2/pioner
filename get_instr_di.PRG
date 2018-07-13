* получить наименование инструмента по коду
lparameters parKodi

local res
local hh,rr

res = 0

hh = sqlconnect('sqldb','sa','111')
if hh>0
	rr = sqlexec(hh,'select * from instr where kodi = ?parKodi','cc81')
	if rr = -1
		eodbc('get_instr_di sele')
	endif
	
	select cc81
	if reccount()>0
		res = cc81.di
	endif
	
	use in cc81
	sqldisconnect(hh)	
else
	eodbc('get_instr_di conn')
endif

return res
