* подпрограмма для показа сообщения о выполнении выборки
* должны присутствовать 2 глоб-е переменные
*	glLastProc
*	glLastTime
lparameters parRecno,parReccount,parStr

local nnn

nnn = int(100*parRecno/parReccount)

if nnn <> glLastProc
	local ttm,vrem,vrems
	ttm = seconds()
	
	vrem = (100 - nnn) * (ttm - glLastTime)
	
	if vrem > 60
		vrems = alltrim(str(int(vrem/60))) + ' мин.'
	else
		vrems = alltrim(str(vrem)) + ' сек.'
	endif

	wait window nowait parStr + ' ' + alltrim(str(nnn)) + '% (ост. ' + vrems + ')'  
	glLastProc = nnn
	glLastTime = seconds()
endif

return



