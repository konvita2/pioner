* определить входит ли маршрут в список маршрутов по 
* производственной базе

lparameters parShwz,parKornd,parMar

local res
res = .f.

local hh
hh = sqlconnect('sqldb','sa','111')
if hh > 0
	
	local rr
	rr = sqlexec(hh,'select top 1 * from ww where rtrim(shwz) = rtrim(?parShwz) '+;
		'and rtrim(kornd) = rtrim(?parkornd) and mar = ?parmar')
	do	case
		case	rr = -1
			eodbc()
		case	rr = 0
			res = .f.
		case	rr > 0 
			res = .t.
	endcase 
	
	sqldisconnect(hh)
else
	eodbc()
endif

return res

*!*	lparameters parShwz,parKornd,parMar
*!*	mres = .f.

*!*	select * from ww ;
*!*		where alltrim(shwz) == alltrim(parShwz) and ;
*!*			alltrim(kornd) == alltrim(parKornd) and;
*!*			mar = parMar;
*!*		into cursor c400
*!*	if reccount()>0
*!*		mres = .t.
*!*	endif	
*!*	use in c400	

*!*	return mres