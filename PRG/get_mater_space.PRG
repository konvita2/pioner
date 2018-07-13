* получить наименование материала по kodm
* если код материала 0 - возращает ''
lparameters parkodm
local hh,rr,res

res = ''

hh = sqlconnect('sqldb','sa','111')
if hh > 0
	local rr
	rr = sqlexec(hh,'select * from mater where kodm = ?parkodm')
	if rr = -1
		eodbc()
	else
		select sqlresult
		if reccount()>0
			res = sqlresult.naim
		endif
	endif
	
	sqldisconnect(hh)
else
	eodbc()
endif

return res

*** <<<
*!*	local svWA,lcRes

*!*	m.svWA = select()

*!*	select * from mater where kodm = m.parKodm and kodm <> 0 into cursor cc_mater

*!*	if reccount()>0
*!*	    m.lcRes = cc_mater.naim
*!*	else
*!*	    m.lcRes = ''
*!*	endif

*!*	use in cc_mater

*!*	select (svWA)

*!*	return m.lcRes
*** >>>