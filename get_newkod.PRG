* 
*!*	lparameters partab
*!*	local res
*!*	res = 0

*!*	select * from newkod where alltrim(tabl) == alltrim(partab) ;
*!*		and !empty(tabl) into cursor cccc
*!*	if reccount()>0
*!*		res = cccc.newid
*!*		update newkod set newid = res+1 where alltrim(tabl) == alltrim(partab) and !empty(tabl)
*!*	endif
*!*	use in cccc

*!*	return res

lparameters partab

local res
res = 0

select 0
use newkod again

do while isflocked()
enddo

if !isflocked()
	flock()
	locate for alltrim(tabl) == alltrim(partab)
	scatter memvar 
	res = m.newid
	replace newid with res+1
	unlock
endif

use

return res