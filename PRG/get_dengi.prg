* получить деньги по таблице tarif
lparameters parSetka,parRr
local res
res = 0

local hh,rr
hh = sqlconnect('sqldb','sa','111')
if hh > 0
	rr = sqlexec(hh,'select * from tarif where vidts=?parsetka and rr=?parrr','c0tarif')
	if rr = -1
		eodbc('get_dengi sele')
	endif
	select c0tarif
	if reccount()>0
		res = c0tarif.dengi
	endif
	use in c0tarif
	sqldisconnect(hh)
else
	eodbc('get_dengi conn')
endif
release hh,rr

*!*	select * from tarif ;
*!*		where vidts=parSetka and rr = parRr ;
*!*		into cursor c0tarif
*!*	if reccount()>0
*!*		res = c0tarif.dengi
*!*	endif	
*!*	use in c0tarif

return res

