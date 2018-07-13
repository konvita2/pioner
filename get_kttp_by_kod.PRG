lparameters parsim

local hh,rr,res

res = ''

if !empty(parsim)
	hh = sqlconnect('sqldb','sa','111')
	if hh > 0
		rr = sqlexec(hh,'select * from dosp where vid=9 and rtrim(sim)=rtrim(?parsim)','cdkttp')
		if rr = -1
			eodbc('get_kttp_by_kod sele')
		endif

		select cdkttp
		if reccount()>0
			res = alltrim(cdkttp.im)
		endif

		use in cdkttp
		sqldisconnect(hh)
	else
		eodbc('get_kttp_by_kod conn')
	endif
endif

return res