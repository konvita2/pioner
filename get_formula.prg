lparameters parKod
local svWA,res

svWA = select()

select * from vidoper where kod = parKod into cursor c50
if reccount()>0
	res = c50.formula
else
	res = '1'
endif
use in c50

select (svWA)

return res
