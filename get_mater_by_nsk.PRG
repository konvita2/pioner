lparameters parnsk
local hh,rr,res

res = ''

hh = sqlconnect('sqldb','sa','111')
if hh <> 0
	rr = sqlexec(hh,'select top 1 * from ostatok where nsk = ?m.parnsk','cc11')
	if rr = -1
		eodbc('get_mater_by_nsk selecting')
	else
		select cc11
		if reccount()>0
			res = get_mater(cc11.kodm)
		endif
		use in cc11	
	endif
	sqldisconnect(hh)
else
	eodbc('get_mater_by_nsk connecting')
endif

return res



*!*	lparameters parNsk

*!*	select * from ostatok ;
*!*		where nsk = parNsk ;
*!*		into cursor cc11
*!*	if reccount()>0
*!*		res = get_mater(cc11.kodm)
*!*	else
*!*		res = ''
*!*	endif 	
*!*	use in cc11	

*!*	return res