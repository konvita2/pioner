lparameters parnomlim,parnompz
local hh,rr

hh = sqlconnect('sqldb','sa','111')
if hh > 0
	rr = sqlexec(hh,'insert into wwpz (nomlim,nompz) values (?m.parnomlim,?m.parnompz)')
	if rr = -1
		eodbc()
	endif
	sqldisconnect(hh)
else
	eodbc()
endif


