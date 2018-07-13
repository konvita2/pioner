* получить из kornd то что после 2-й точки
lpara parKornd
local mres,mpp,mn

mres = ''
mpp = alltrim(parKornd)

mn = at('.',mpp,2)
if mn > 0
	mres = right(mpp,len(mpp)-mn)
endif

return mres


