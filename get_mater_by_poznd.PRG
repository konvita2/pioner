lparameters parpoznd
local res,hh,rr

res = ''

return '' && temp

hh = sqlconnect('sqldb','sa','111')
if hh > 0
	rr = sqlexec(hh,"select top 1 * from ww "+;
					"where poznd <> '' and rtrim(poznd) = rtrim(?m.parpoznd)",'c505')
	if rr = -1
		eodbc('get_mater_by_poznd selection')
	else
		select c505
		if reccount()>0
			res = get_mater(c505.kodm)
		endif
		use in c505
	endif				
	sqldisconnect(hh)
else
	eodbc('get_mater_by_poznd connection')
endif

return res
