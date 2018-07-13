* получить наименование из справ-ка профессий если оно есть
lparameters parKod
local svWA,lcRes

m.svWA = select()

*!*	select * from dosp ;
*!*		where kod<>0 and kod <> 9999 and vid=5 and kod = m.parKod ;
*!*		into cursor cc_dosp5


hhh = SQLConnect('sqldb','sa','111')
	If hhh > 0
		rrr = SQLExec(hhh,'select * from dosp where kod<>0 and kod <> 9999 and vid=5 and kod = ?m.parKod','cc_dosp5')
		If rrr = -1
			eodbc('f_wkp fp_c WW Sele')
		Endif
		SQLDisconnect(hhh)
	Else
		eodbc('f_wkp fp_c WW conn')
	endif
if reccount()>0
	m.lcRes = cc_dosp5.im
else
	m.lcRes = '(не указан)                                       '
endif	
use in cc_dosp5

select (svWA)

return m.lcRes