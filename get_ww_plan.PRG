* получить признак спланированности 
lparameters parShwz
local isplan,isnoplan,res

select kolz,kzp from ww where kolz = kzp and alltrim(shwz) == alltrim(parShwz) into cursor cc999

* =================
if reccount()>0
	res = '+'
else
	res = ''
endif

use in cc999

return res