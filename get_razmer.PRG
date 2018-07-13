lparameters parpoznd
local res,hh,rr

res = ''

hh = sqlconnect('sqldb','sa','111')
if hh>0
	rr = sqlexec(hh,"select * from ww where rtrim(poznd)<>'' and rtrim(poznd)=rtrim(?parpoznd)",'c505')
	if rr = -1
		eodbc('get_razmer sele')
	endif
	
	select c505
	if reccount()>0
		res = ' ('+alltrim(str(c505.rozma))+' X '+alltrim(str(c505.rozmb))+')'	
	endif
	use in c505
	sqldisconnect(hh)
else
	eodbc('get_razmer conn')
endif

return res

*//////////////////////////////////
*!*	lparameters parPoznd
*!*	local res

*!*	select * from ww ;
*!*		where !empty(poznd) and alltrim(poznd) == alltrim(parPoznd) ;
*!*		into cursor c505
*!*	if reccount()>0
*!*		res = ' ('+alltrim(str(c505.rozma))+' X '+alltrim(str(c505.rozmb))+')'
*!*	else
*!*		res = ''	
*!*	endif	
*!*	use in c505	

*!*	return res