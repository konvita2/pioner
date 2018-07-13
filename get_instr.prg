* получить наименование инструмента по коду
lparameters parKodi

local res
res = ''

*** select * from instr where kodi = parKodi into cursor cc81
local hh,rr
hh = sqlconnect('sqldb','sa','111')
if hh>0
	rr = sqlexec(hh,'select * from instr where kodi=?parkodi','cc81')
	if rr = -1
		eodbc('get_instr sele')
	endif

	select cc81
	if reccount()>0
		res = cc81.im
	else
		res = ''
	endif
	use in cc81

	sqldisconnect(hh)
else
	eodbc('get_instr conn')
endif

return res