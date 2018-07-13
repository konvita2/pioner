lparameters parKod,parUs
local res,hh,rr
*!*	wait window 'parkod='+str(parkod)+'   parus='+str(parus)
hh = SQLConnect('sqldb','sa','111')
If hh = 0
	eodbc('tokar_prg conn')
Endif
rr = SQLExec(hh,'select * from DOSP where vid=30 and kod = ?parKod and us = ?parUs','cc83')
*!*	brow
If rr = -1
	eodbc('tokar_prg_te sele')
Endif
if reccount()>0
	res =ALLTRIM(cc83.im+' '+ALLTRIM(sim))
else
	res = ''
endif
use in cc83

return res


