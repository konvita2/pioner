lparameters parKod,parkttp,parkof1,parkof2
local res,hh,rr

*!*	wait window parkttp+' kod='+str(parkod)+' kof='+str(parkof)
hh = SQLConnect('sqldb','sa','111')
If hh = 0
	eodbc('tokar_prg conn')
Endif
rr = SQLExec(hh,'select im from ktu where LEFT(ttp,11)=left(?parkttp,11) and npp=?parkod and (kof=?parkof1 or kof=?parkof2)','cc83')

If rr = -1
	eodbc('tokar_prg_te sele')
Endif
if reccount()>0
	res = cc83.im
else
	res = ''
endif
use in cc83

return res


