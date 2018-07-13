lparameters parkodm
local mres,hh,rr
mres = 0

hh = sqlconnect('sqldb','sa','111')
if hh > 0
	rr = sqlexec(hh,'select uv from mater where kodm = ?parkodm','cr100')
	if rr = -1
		eodbc('get_mater_uv selection')
	else
		select cr100
		if reccount()>0
			mres = cr100.uv
		endif		
		use in cr100
	endif
	
	
	sqldisconnect(hh)
else
	eodbc('get_mater_uv connection')
endif

return mres