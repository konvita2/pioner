* получить kto по справочнику подразделений
* используется при формировании ww по временной схеме
lparameters parMar
local mres
mres = 0

local hh
hh = sqlconnect('sqldb','sa','111')
if hh > 0
	
	local rr
	
	rr = sqlexec(hh,'select top 1 * from dosp where vid = 2 and kod = ?parmar')
	if rr > -1
		select sqlresult
		if reccount()>0
			mres = val(sqlresult.obor)
		endif		
	else
		eodbc()		
	endif		
	
	sqldisconnect(hh)
else
	eodbc()
endif

return mres


 