lparameters parkodm
local mres,hh,rr
mres = 0

hh = sqlconnect('sqldb','sa','111')
if hh > 0
	rr = sqlexec(hh,'select tver from mater where kodm = ?parkodm','cr100')
	if rr = -1
		eodbc('get_mater_tver selection')
	else
		select cr100
		if reccount()>0
			mres = cr100.tver
		endif		
		use in cr100
	endif
	
	
	sqldisconnect(hh)
else
	eodbc('get_mater_tver connection')
endif

return mres