lparameters parShw,parKornd
local mres
mres = ''

local hh,rr
hh = sqlconnect('sqldb','sa','111')
if hh > 0
	rr = sqlexec(hh,'select * from kt where shw = ?parshw and rtrim(kornd) = rtrim(?parkornd)','cc112')
	if rr = -1
		eodbc('get_poznd_by_shw_kornd sele')
	endif
	
	select cc112
	if reccount()>0
		mres = alltrim(cc112.kornw)
	endif

	sqldisconnect(hh)
	use in cc112
else
	eodbc('get_poznd_by_shw_kornd conn')
endif

return mres


*!*	lparameters parShw,parKornd
*!*	local mres
*!*	mres = ''

*!*	select kornw from kt where shw = parShw and alltrim(kornd) == alltrim(parKornd) ;
*!*		into cursor cc112
*!*	if reccount()>0
*!*		mres = cc112.kornw
*!*	endif	
*!*	use in cc112	

*!*	return mres

