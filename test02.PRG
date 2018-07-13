local hh,rr

hh = sqlconnect('sqldb','sa','111')
if hh > 0
	rr = sqlexec(hh,'select * from mater')
	if rr = -1
		wait window 'Ошибка выполнения'
	else
		select sqlresult
		scan all
			? sqlresult.kodm
		endscan 
		
	endif
	sqldisconnect(hh)
else
	wait window 'Ошибка подключения'
endif
