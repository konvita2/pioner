* получить новое значение nozap для таблицы
lparameters parTable
local svWA,res
m.svWA = select()

select * from (parTable) ;
	order by nozap ;
	into cursor c_ress
if reccount()>0
	go bottom 
	m.res = c_ress.nozap + 1
else
	m.res = 1
endif
use in c_ress

select (svWA)

return m.res

