* получить количество изделий в заказе имитационной базы
lparameters parNom,parShw
local hh,rr
local res

res = 0

hh = sqlcn()
if hh > 0
	rr = sqlexec(hh,'select * from imittp where nom=?parNom and shw=?parShw','c088')
	if rr = -1
		eodbc('get_imittp_kolizd sele')			
	else
		select c088
		if reccount()>0
			res = c088.kol
		endif		
		use in c088
	endif
	sqldisconnect(hh)
else
	eodbc('get_imittp_kolizd conn')	
endif

return res