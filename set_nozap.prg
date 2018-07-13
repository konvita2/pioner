* * * * * * * * * * * * * * * * * * * * * * * * * *
* Установить nozap в таблицах
* * * * * * * * * * * * * * * * * * * * * * * * * *
lparam parTable
local nRec

m.nRec = 1
close tables all
use (parTable) alias al_work

scan all
	replace nozap with m.nRec
	m.nRec = m.nRec + 1
endscan

use in al_work

return