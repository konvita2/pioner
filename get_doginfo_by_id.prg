* получить информацию договора по id
lparameters pardogid

local res,hh,rr

res = ''

hh = sqlconnect('sqldb','sa','111')
if hh > 0
	rr = sqlexec(hh,'select * from dbo.vdogovor where id = ?pardogid','sqldog')
	if rr = -1
		eodbc('get_doginfo_by_id sele')
	else
		res = 'Договор №' + allt(sqldog.nom) +;
			' от ' + dtoc(ttod(sqldog.dat)) + ' c ' +;
			alltrim(sqldog.kontnaim) + ' (' + ;
			alltrim(sqldog.kontadr) + ')'
		use in sqldog
	endif
	
	sqldisconnect(hh)
else
	eodbc('get_doginfo_by_id conn')
endif

return res
