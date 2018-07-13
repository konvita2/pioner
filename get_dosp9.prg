* получить наименование из справ-ка типовых техпроцессов
lparameters parSim
local svWA,lcRes

m.svWA = select()

select * from dosp ;
	where kod<>0 and kod <> 9999 and vid=9 and alltrim(sim) == alltrim(m.parSim) ;
	into cursor cc_dosp9
if reccount()>0
	m.lcRes = cc_dosp9.im
else
	m.lcRes = '(не указан)                                       '
endif	
use in cc_dosp9

select (svWA)

return m.lcRes