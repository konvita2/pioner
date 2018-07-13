local hh,rr
local mgod

hh = sqlconnect('sqldb','sa','111')
if hh > 0
	rr = sqlexec(hh,'select * from ras','crast')
	if rr = -1
		eodbc('error ras select')
	else
		select crast
		scan all
			mgod = year(crast.dat)
			mnom = crast.nom
			mnom1 = crast.nom1
			
			rr = sqlexec(hh,'update ras set god = ?mgod where nom=?mnom and nom1=?mnom1')
			if rr = -1
				eodbc('ras update')	
			else
				wait window nowait 'ras ' + str(mnom) + '.' + str(mnom1) + ' ok!' 
			endif
			
			* rast
			rr = sqlexec(hh,'update rast set god = ?mgod where nom=?mnom and nom1=?mnom1')
			if rr = -1
				eodbc('rast update')	
			else
				wait window nowait 'rast ' + str(mnom) + '.' + str(mnom1) + ' ok!' 
			endif
		endscan
		
	endif
	sqldisconnect(hh)
else
	eodbc('connect error')
endif