* проверить есть ли такой шифр запуска в производственной базе
lparameters parShwz
local res
res = ''

local hh,rr
hh = sqlconnect('sqldb','sa','111')
if hh > 0

	*select shwz from ww where alltrim(shwz) == alltrim(parShwz) into cursor c888
	
	rr = sqlexec(hh,'select shwz from ww where rtrim(shwz) = rtrim(?parShwz)','c888')
	if rr = -11
		eodbc('get_ww_is sele')
	endif
	
	select c888
	if reccount() > 0
		res = '+'
	endif
	use in c888

	return res
	
	sqldisconnect(hh)
else
	eodbc('get_ww_is conn')
endif



