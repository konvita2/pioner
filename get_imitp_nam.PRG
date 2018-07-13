* получить примечание по имитационному заказу
lparameters parNom
local hh,rr
local res

res = ''

hh = sqlcn()
if hh > 0
	rr = sqlexec(hh,'select * from imitp where nom = ?parNom','c089')
	if rr = -1
		eodbc('get_imitp_nam sele')
	else
		select c089
		if reccount()>0
			res = alltrim(c089.nam)
		endif	
		use in c089
	endif
	sqldisconnect(hh)
else
	eodbc('get_imitp_nam conn')
endif 

return res
