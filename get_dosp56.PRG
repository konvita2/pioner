* получить наименование из справ-ка кодов заготовок если оно есть
lparameters parkod

local res,rr,hh

res = space(40)

if parkod = 0
	return res
endif

hh = sqlconnect('sqldb','sa','111')
if hh > 0
	rr = sqlexec(hh,'select * from dosp where vid=56 and kod = ?parkod')
	if rr = -1
		eodbc()
	else
		select sqlresult
		go top
		res = sqlresult.im
	endif	
else
	eodbc()
endif

return res
