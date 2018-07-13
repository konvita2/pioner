* получить новый код для изделия
local res,hh,rr,mres

res = -1

hh = sqlconnect('sqldb','sa','111')
if hh > 0
	mres = 0
	rr = sqlexec(hh,'exec my_izd_new_kod ?@mres')
	if rr = -1
		eodbc()
	else
		res = int(mres)		
	endif
	
	sqldisconnect(hh)
else
	eodbc()
endif

return res