* получить im изделия по имитационной базе по shwz
lparameters parShwz
local mshwz,mres

mshwz = parShwz

mres = space(40)

select * from imit where alltrim(shwz) == alltrim(mshwz) and !empty(shwz) into cursor c45
if reccount()>0
	mres = alltrim(get_izd_im_by_kod(c45.izd))
endif
use in c45

return mres