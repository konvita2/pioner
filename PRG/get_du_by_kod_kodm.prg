*** определить вид материала по коду изделия и коду материала
*** под видом материала понимаем
*** 1 - основные
*** 4 - покупные
*** 5 - вспомогательные
lparameters parShw,parKodm
local mres,mshw
mres = 0
mshw = parShw

local hh,rr
hh = sqlconnect('sqldb','sa','111')
if hh > 0
	rr = sqlexec(hh,'select d_u from kt where kodm=?parkodm and shw=?mshw','cc_99')
	if rr = -1
		eodbc('form_shwzimi_new sele')
	endif
	select cc_99
	if reccount()>0
		mres = cc_99.d_u
	endif
	sqldisconnect(hh)
else
	eodbc('form_shwzimi_new conn')
endif
release hh,rr

*!*	select d_u from kt where kodm = parKodm and shw = mshw into cursor cc_99
*!*	if reccount()>0
*!*		mres = cc_99.d_u
*!*	endif
*!*	use in cc_99

return mres