* получить дату план-задания по номеру и маршруту
lparameters parNzad,parMar
local mres
mres = ctod('')

*** <<<
*!*	select * from pz where nzad = parNzad and mar = parMar into cursor c34
*!*	if reccount()>0
*!*		mres = c34.dat
*!*	endif
*!*	use in c34
*** >>>

local hh
hh = sqlconnect('sqldb','sa','111')
if hh > 0
	local rr
	rr = sqlexec(hh,'select * from pz where nzad = ?parnzad and mar = ?parmar')
	if rr = -1
		eodbc()
	else
		select sqlresult
		if reccount()>0
			go top
			mres = sqlresult.dat	
		endif
	endif
	sqldisconnect(hh)
else
	eodbc()
endif

return mres
