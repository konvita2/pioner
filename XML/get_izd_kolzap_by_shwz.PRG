lparameters parShwz

local mres
local mpartz1,mpartz2

mpartz1 = get_izd_partz1_by_shwz(parShwz)
mpartz2 = get_izd_partz2_by_shwz(parShwz)

return mpartz2-mpartz1+1

