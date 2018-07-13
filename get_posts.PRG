* получить строку (наименование + адрес поставшщика по коду)
lparameters parId
local res
local hh,rr

res = ''

hh = sqlconnect('sqldb','sa','111')
if hh > 0
	rr = sqlexec(hh,'select * from kontrag where id = ?parid','cdkon')
	if rr = -1
		eodbc('get_posts sele')
	endif	
	
	res = alltrim(cdkon.naim) + ' ' + alltrim(cdkon.adr)

	sqldisconnect(hh)
else
	eodbc('get_posts conn')
endif

return res

