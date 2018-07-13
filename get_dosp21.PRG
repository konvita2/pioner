lparameters parkod
local hh,rr,res,sv

sv=select()

hh = sqlconnect('sqldb','sa','111')
if hh>0
	rr = sqlexec(hh,'select * from dosp where kod<>0 and kod<>9999 and vid=21 and kod=?parkod','cc_dosp2')
	if rr = -1
		eodbc('get_dosp21 sele')
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
	eodbc('get_dosp21 conn')
endif

select (sv)

return res


*!*	* получить наименование из справ-ка сортамента
*!*	lparameters parKod
*!*	local svWA,lcRes

*!*	m.svWA = select()

*!*	select * from dosp ;
*!*		where kod<>0 and kod <> 9999 and vid=21 and kod = m.parKod ;
*!*		into cursor cc_dosp2
*!*	if reccount()>0
*!*		m.lcRes = cc_dosp2.im
*!*	else
*!*		m.lcRes = '(не указан)                                       '
*!*	endif	
*!*	use in cc_dosp2	

*!*	select (svWA)

*!*	return m.lcRes

