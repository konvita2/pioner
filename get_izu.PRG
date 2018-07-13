* получить наименование инструмента по коду
lparameters PARVID,parKKO,parKodi
*!*	WAIT WINDOW 'GET_IZU.PRG RI='+STR(PARKODI)
local res
res = ''

local hh,rr
hh = sqlconnect('sqldb','sa','111')
if hh>0
	rr = sqlexec(hh,'select im from izu where VID=?PARVID and kko=?parkko AND KODI=?parkodi','cc81')
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