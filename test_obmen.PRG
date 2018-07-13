* проверить было ли нормально выполнено обновление остатков и 
* предложить сделать обновление
local mtime,mfl,mpredtime

mpredtime = getnastr('obmentime')
mfl = getnastr('ostatpath')
if !empty(mfl)
	mtime = ftime(mfl)
	if alltrim(mpredtime) <> alltrim(mtime)
		local ms
		ms = 'Время загрузки последних остатков отличается от времени файла обмена. Закачать более свежие остатки?'
		if messagebox(ms,4+32,'ВНИМАНИЕ!')=6
			do loadspr_new
		endif	
	endif	
endif