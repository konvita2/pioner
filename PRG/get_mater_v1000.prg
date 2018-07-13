lparameters parkodm
local mres,hh,rr
mres = 0

hh = sqlcn()
if hh > 0
	rr = sqlexec(hh,'select v1000 from mater where kodm = ?parkodm','cr100')
	if rr = -1
		eodbc('get_mater_v1000 selection')
	else
		select cr100
		if reccount()>0
			mres = cr100.v1000
		endif		
		use in cr100
	endif	
	sqldisconnect(hh)
else
	eodbc('get_mater_v1000 connection')
endif

return mres