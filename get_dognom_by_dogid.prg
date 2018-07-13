* получить номер договора по id
lparameters parid
local hh,rr
local res

res = ''

hh = sqlconnect('sqldb','sa','111')
if hh > 0
	rr = sqlexec(hh,'select nom from dogovor where id = ?parid','ccdd')	
	if rr = -1
		eodbc('get_dognom_by_dogid sele')
	endif
	select ccdd
	if reccount()>0
		res = ccdd.nom
	endif
	use in ccdd
	sqldisconnect(hh)	
else
	eodbc('get_dognom_by_dogid conn')
endif

return res
