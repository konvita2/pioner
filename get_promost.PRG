* получить остаток материала по промежуточным складам
lparameters parsklad,parkodm
local res,hh,rr,mm

mm = 0
res = 0

hh = sqlconnect('sqldb','sa','111')
if hh > 0
	rr = sqlexec(hh,'exec dbo.my_mf_get_promost ?parsklad,?parkodm,?@mm')
	if rr = -1
		eodbc('get_promost exec')
	else
		res = mm
	endif
	sqldisconnect(hh)
else
	eodbc('get_promost conn')
endif

return res