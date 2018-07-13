local hh,rr

hh = sqlconnect('sqldb','sa','111')
if hh > 0
	rr = sqlexec(hh,'insert into dosp (vid,kod) values (2,1001)')
	if rr = -1
		eodbc()
	else
		select sqlresult
		browse	
	endif


else
	eodbc()
endif