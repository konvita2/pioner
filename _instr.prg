* закачка инструментов

hh = sqlconnect('sqldb','sa','111')
if hh > 0
	use _instr
	scan all
		wait window nowait str(reccount()) + ' ' + _instr.kod
		mkod = val(_instr.kod)
		mnam = _instr.nam
		rr = sqlexec(hh,'insert into instr (kodi,im) values (?mkod,?mnam)')
		if rr = -1
			eodbc('_instr insert ' + _instr.kod)
		endif	
	endscan
	sqldisconnect(hh)
else
	eodbc('_instr conn')
endif

