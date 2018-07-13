* 750.500.399.061.08  

local hh,rr
local mshwz

mshwz = '750.500.399.061.08'

hh = sqlconnect('sqldb','sa','111')
if hh > 0
	rr = sqlexec(hh,'select * from ww where rtrim(shwz) = ?mshwz','ccc')
	if rr = -1
		eodbc('test022 sele')
	endif

	scan all
		wait window nowait 'Progress ' + alltrim(str(100*recno()/reccount())) + '%' 
		add_wwlim(ccc.nozap,ccc.kolz)
	endscan 
	
	use in ccc
	sqldisconnect(hh)
else
	eodbc('test022 conn')
endif
