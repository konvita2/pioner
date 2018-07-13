* получить технолог единицу материала по kodm
lparameters parKodm
local svWA,lcRes

local hh
hh = sqlcn()
if hh > 0
	local rr 
	rr = sqlexec(hh,'select * from mater where kodm = ?parkodm')
	if rr > -1
		if rr > 0
			select sqlresult
			m.lcRes = alltrim(sqlresult.ei)
		else
			m.lcRes = ''
		endif		
	else
		eodbc('get_mater_ei selection')
	endif	
	sqldisconnect(hh)
else
	eodbc('get_mater_ei connection')
	m.lcRes = ''
endif

return m.lcRes