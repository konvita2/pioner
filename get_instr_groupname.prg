lparameters lpnKod
local lcRes,svWA

m.svWA = select()
select 0
select * from dosp ;
	where kod<>0 and vid=34 and kod=m.lpnKod ;
	into cursor c816
if reccount()>0
	m.lcRes = c816.im
else
	m.lcRes = '(не определена)'
endif	
use in c816	

select (m.svWA)

return m.lcRes

