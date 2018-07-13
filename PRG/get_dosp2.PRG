* получить наименование из справ-ка подразделение если оно есть
lparameters parKod
local svWA,lcRes
local hh,rr

hh = sqlconnect('sqldb','sa','111')
if hh > 0
	local rr
	rr = sqlexec(hh,'select * from vdosp2 where kod = ?parkod','cdosp21')
*!*		brow
	if rr > 0
		select cdosp21
		lcres = alltrim(cdosp21.im)		
	else
		lcres = ''	
	endif
	
	use in cdosp21
	
	sqldisconnect(hh)	
else
	eodbc('get_dosp2')
	lcres = ''
endif

return m.lcRes

