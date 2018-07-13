* получить остаток по коду материала
* на сегодня и по основному складу
lparameters parKodm
local res,mskl,mdat,most,res1

mdat = date()
res = 0
most = 0
res1 = -1

local hh
hh = sqlconnect('sqldb','sa','111')
if hh > 0

	res1 = sqlexec(hh,'exec my_get_ostatok ?parKodm,?mdat,?@most')
	if res1 > 0
		res = most
	else
		eodbc()
	endif	
	
	sqldisconnect(hh)
else
	eodbc()
endif

return res

