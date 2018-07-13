* получить наименование из справ-ка технологических операций
lparameters parkod

local res,rr,hh

res = space(40)

hh = sqlconnect('sqldb','sa','111')
if hh > 0
	rr = sqlexec(hh,'select * from dosp where vid=7 and kod = ?parkod')
	if rr = -1
		eodbc()
	else
		select sqlresult
		go top
		res = sqlresult.im
	endif	
else
	eodbc()
endif

return res

*** <<<
*!*	lparameters parKod
*!*	local svWA,lcRes

*!*	m.svWA = select()

*!*	select * from dosp ;
*!*		where kod = parKod and kod <> 9999 and vid=7 ;
*!*		into cursor cc_dosp7
*!*	if reccount()>0
*!*		m.lcRes = cc_dosp7.im
*!*	else
*!*		m.lcRes = '(не указан)                                       '
*!*	endif	
*!*	use in cc_dosp7

*!*	select (svWA)

*!*	return m.lcRes
*** >>>