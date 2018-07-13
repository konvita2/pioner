* получить по ШЗ и коду материала его количество на запуск из этбазы
lparameters parshwz,parkodm,parmar2
local res

res = 0

local h,r
h = sqlconnect('sqldb','sa','111')
if h > 0
	r = sqlexec(h,	'select * from shwzras02 where kodm=?parkodm and '+;
					'rtrim(shwz) = rtrim(?parshwz) and mar2 = ?parmar2','ccd1')
	if r = -1
		eodbc('get_shwzras_kol_by_shwz_and_kodm_and_mar2 sele')
	endif				
	select ccd1
	if reccount()>0
		res = ccd1.kolizd * ccd1.kol1
	endif
	sqldisconnect(h)
else
	eodbc('get_shwzras_kol_by_shwz_and_kodm_and_mar2 conn')
endif
release h,r

*!*	select * from shwzras where kodm = parkodm and alltrim(shwz) == alltrim(parshwz) into cursor ccd1
*!*	if reccount()>0
*!*		res = ccd1.kol1 * ccd1.kolizd
*!*	endif
*!*	use in ccd1

return res


