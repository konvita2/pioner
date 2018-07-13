lparameters parkod
local hh,rr,sv
local res

sv = select()

hh = sqlconnect('sqldb','sa','111')
if hh>0
	rr = sqlexec(hh,'select * from dosp where kod<>0 and kod<>9999 and vid=26 and kod=?parkod','cc_dosp2')
	if rr = -1
		eodbc('get_dosp26 sele')
	endif
	
	select cc_dosp2
	if reccount()>0
		res = cc_dosp2.im
	else
		res = '(не указан)                                       '
	endif

	use in cc_dosp2
	sqldisconnect(hh)
else
	eodbc('get_dosp26 conn')
endif

select (sv)

return res



*!*	* получить наименование из справ-ка uhegg vfnthbfkjd
*!*	lparameters parKod
*!*	local svWA,lcRes

*!*	m.svWA = select()

*!*	select * from dosp ;
*!*		where kod<>0 and kod <> 9999 and vid=26 and kod = m.parKod ;
*!*		into cursor cc_dosp2
*!*	if reccount()>0
*!*		m.lcRes = cc_dosp2.im
*!*	else
*!*		m.lcRes = '(не указан)                                       '
*!*	endif	
*!*	use in cc_dosp2	

*!*	select (svWA)

*!*	return m.lcRes

