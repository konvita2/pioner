lparameters parPoznd,parShwz

local res,sqla
res = ''

if empty(parShwz)  
	sqla = 'select top 1 * from ww where rtrim(poznd) = rtrim(?parpoznd)'
else
	sqla = 'select top 1 * from ww where rtrim(poznd) = rtrim(?parpoznd) and shwz = rtrim(?parshwz)'
endif

local hh
hh = sqlconnect('sqldb','sa','111')
if hh > 0
	local rr
	rr = sqlexec(hh,sqla)
	if rr > 0
		if sqlresult.kolzag > 1
			res = '[' + alltrim(str(sqlresult.kolzag)) + ']'
		endif	
	endif	

	sqldisconnect(hh)
else
	eodbc()
endif

return res




*!*	lparameters parPoznd

*!*	local res
*!*	res = ''

*!*	select * from ww where alltrim(poznd) == alltrim(parPoznd);
*!*		into cursor c980
*!*	if reccount()>0
*!*		go top
*!*		if c980.kolzag > 1
*!*			res = '[' + alltrim(str(c980.kolzag)) + ']'
*!*		endif	
*!*	endif
*!*	use in c980	

*!*	return res
