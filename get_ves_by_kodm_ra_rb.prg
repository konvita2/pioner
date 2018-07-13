* получить вес листового материала указанного размера
lparameters parKodm, parRa, parRb
local res
m.res = 0

select * from mater where kodm = parKodm into cursor c113
if reccount()>0
	m.res = parRa * parRb * c113.tm * c113.uv / 1000000	
endif
use in c113

return m.res
