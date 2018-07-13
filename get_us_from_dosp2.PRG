* получить поле us из спр-ка подр
lparameters parKod
local mres

mres = 0

local hh
hh = sqlconnect('sqldb','sa','111')
if hh > 0
	local rr
	
	rr = sqlexec(hh,'select top 1 * from dosp where vid=2 and kod = ?parkod')
	if rr > -1
		select sqlresult
		if reccount()>0
			mres = sqlresult.us
		endif		
	else
		eodbc()
	endif	

	sqldisconnect(hh)
else
	eodbc()
endif

return mres
