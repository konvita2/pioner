* получить наименование технологической операции по коду
lparameters parKod

local svRes
local svWA

local hh
hh = sqlconnect('sqldb','sa','111')
if hh > 0

	local rr
	rr = sqlexec(hh,'select im from vdosp7 where kod = ?parkod','ccvdosp7')
	if rr > 0
		svres = alltrim(ccvdosp7.im)
	else
		svres = ''
	endif
	
	sqldisconnect(hh)
else
	eodbc('get_kto_naim_by_kod conn')
endif

return m.svRes
