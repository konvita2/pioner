lparameters parNom,parShw,parPoznw
local res,hh,rr

res = 0

hh = sqlcn()
if hh > 0
	rr = sqlexec(hh,'select * from imitu where nom=?parNom and shw=?parShw and '+;
				'rtrim(poznw)=rtrim(?parPoznw)','c00')
	if rr = -1
		eodbc('get_imitu_kol sele')
	else
		select c00
		if reccount()>0
			res = c00.kol		
		endif
		use in c00
	endif
	sqldisconnect(hh)
else
	eodbc('get_imitu_kol conn')
endif

return res
 