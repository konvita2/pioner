lparameters parsql,pararea,parmsg
local hh,rr

hh = sqlconnect('sqldb','sa','111')
if hh > 0
	rr = sqlexec(hh,parsql,pararea)
	if rr = -1
		eodbc(parmsg + ' oper ')
	endif	
	sqldisconnect(hh)
else
	eodbc(parmsg + ' conn ')
endif

return
