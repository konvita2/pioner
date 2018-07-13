lparameters parShwz,parKodm
local mres,mshw

mres = ''

mshw = get_izd_kod_by_shwz(parShwz)

select * from kt where shw = mshw and kodm = parKodm and !empty(ei1) into cursor cc98
if reccount()>0
	mres = cc98.ei1
endif
use in cc98

return mres