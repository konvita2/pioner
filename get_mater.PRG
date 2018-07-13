* получить наименование материала по kodm
lparameters parKodm
local svWA,lcRes

local hh
hh = sqlconnect('sqldb','sa','111')
if hh > 0
	local rr 
	rr = sqlexec(hh,'select top 1 * from mater where kodm = ?parkodm','sqlr')
	if rr > -1
		if rr > 0
			select sqlr
			m.lcRes = sqlr.naim
		else
			m.lcRes = '(не найден по коду)'
		endif
				
	else
		eodbc()
	endif	
	use in sqlr
	
	sqldisconnect(hh)
else
	eodbc()
	m.lcRes = '(не найден по коду)'
endif

return m.lcRes