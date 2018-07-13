*** определить вид материала по коду запуска и коду материала
*** под видом материала понимаем
*** 1 - основные
*** 4 - покупные
*** 5 - вспомогательные
lparameters parShwz,parKodm
local mres,mshw
local hh,rr

mres = 0
mshw = get_izd_kod_by_shwz(parShwz)

hh = sqlconnect('sqldb','sa','111')
if hh > 0
	rr = sqlexec(hh,'select top 1 d_u from kt where kodm=?parkodm and shw=?mshw','cc_99')
	if rr = -1
		eodbc('get_du_by_shwz_kodm sele')
	endif
	select cc_99
	if reccount()>0
		mres = cc_99.d_u
	endif	
	sqldisconnect(hh)
	use in cc_99
else
	eodbc('get_du_by_shwz_kodm conn')
endif

return mres

