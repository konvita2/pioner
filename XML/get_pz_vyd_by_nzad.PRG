* получить признак выдан-невыдан по номеру план-задания и участку
* результат 1 или 0
lparameters parNzad,parMar
local mres
mres = 0

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
			mres = sqlresult.vid
		endif	
	endif		
	sqldisconnect(hh)
else
	eodbc()
endif
 
*** <<<
*!*	select * from pz where nzad = parNzad and mar = parMar into cursor c34
*!*	if reccount()>0
*!*		mres = c34.vid
*!*	endif
*!*	use in c34
*** >>>

return mres


